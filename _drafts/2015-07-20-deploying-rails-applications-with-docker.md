---
layout: post
title: "Zero downtime multi-host Docker Rails production deploys using Ansible and HAProxy"
title: "Deploying production Rails applications with Docker and Ansible"
title: "Multi-host, zero downtime, rolling Docker kitten deployments using Ansible and HAProxy"
date: 2015-07-20 12:00
comments: true
categories:
draft: true
published: false
---

This is my fourth Docker-centric post, and probably the last one I'll write about it for a while.  Previously I showed you how I formerly did [local development using Docker and Vagrant][rails-development-docker], then I showed you how to do [simple continuous integration (CI) of Ruby/Rails docker images][rails-docker-ci] using fig, make, and CircleCI, and finally I showed you some reasons on why I [dialed back my use of Docker][why-i-dont-use-docker].  This post will show how I currently deploy my Rails applications as Docker containers using Ansible.

This post will not be how to do anything fancy with Mesos, Kubernetes, Docker Swarm, et. al.  This is about doing the [simplest thing that could possibly work][simplest-thing] - provisioning virtual machines (VMs) across multiple hosts with the Docker containers running right on the hosts.  I will demonstrate using a linked pair of containers - one running the Rails application and one running nginx as a reverse proxy.

Unrelated to Docker, I'll also share how I maximize uptime by proxying Web requests through HAProxy and how to do a "rolling update" using Ansible playbooks.

## Dockerizing Rails best practices

I'm going to assume you already know how to create Docker images for Rails applications (i.e. "dockerizing") by writing Dockerfiles.  If not, Google it because there are a lot of examples out there; otherwise my [continuous integration][rails-docker-ci] post covers a bit of it.

Instead, I'm going to talk about some best practices that I've found helpful that I think other posts miss.

### Dockerfile should be production-oriented

In your Dockerfile, you should be setting `RAILS_ENV=production` and assuming the image you're building will be going to production (so doing asset precompilation and all that good stuff as well).

TODO

### Only three Rails environments: development, test, production

You should have **exactly three** Rails environments defined (`RAILS_ENV` values): `development`, `test`, and `production`. If you have need for other environments, like "staging", "qtest", etc. those should still be using `RAILS_ENV=production`.

This is [advice espoused by Heroku][heroku-dev-prod-parity] as part of their philosophy of maintaining "dev/prod parity," and makes a lot of sense with Docker containers as well. Ideally the Docker image you deploy to production should be the exact same image you deployed to remote QA environments, differing only by configuration information.

So how to differentiate between production and QA environments?  Environment variables!

### Use environment variables!

To differentiate between production and QA environments like "staging", "qtest", etc. which share `RAILS_ENV=production`, you should configure behavior by setting environment variables to different values.  You may have seen this advice espoused by [The Twelve-Factor App][12factor] (because it's good advice!).

Explicit environment checks like `if Rails.env.production?` should be replaced by an `ENV` variable check when possible, like `if ENV['FOO_ENABLED']` (the exception to this being checking `Rails.env.test?`).

#### ENVied - ensure environment variables are defined

Rather than bare `ENV[]` checks, which can be unsafe if you mistype the variable name either in code or when providing it to the app on the command-line, I like to use a gem called [envied][].  This gem introduces a file named Envfile to the root of your project which does two things: ensures that specified ENV variables are defined, and coerces them to the specified Ruby type.  So instead of having to write code like this in configuration files:

```ruby
raise "You forgot to set FOO!" unless ENV['FOO']
if ENV['FOO'].to_i > 10
```

you just put this in your Envfile:

```ruby
variable :FOO, :Integer
```

and then in your application you just write

```ruby
if ENVied.FOO > 10
```

ENVied will abort application startup immediately if a variable specified in the Envfile was not passed in (no manual `raise` required), and it does the type coercion to integer for you as well (no `.to_i` required).

For the sake of comparison, if you're one of those people that hate adding gem dependencies, there's a [Config helper][pliny-config] module in the pliny project that does something very similar that you could crib from.

#### dotenv - provide default environment variables for development

Now that you are requiring environment variables to be passed in, development will suddenly become very painful if you have to start Rails like this:

    FOO=blah BAR=blah BAZ=blah ... bundle exec rails s

Luckily there is a gem that solves this problem called [dotenv][] (for Rails applications, the gem is actually `dotenv-rails`).

Using dotenv, you create a `.env` file in the root of your project with lines like this:

    S3_BUCKET=YOURS3BUCKET
    SECRET_KEY=YOURSECRETKEYGOESHERE

which will automatically set these environment variables in the development environment.  For Rails's test environment, you follow the same pattern but the name of the file is `.env.test`.

There are similar gems out there that solve this problem, but what really impressed me about dotenv is the bash-compatible syntax which allows you to source .env files from bash scripts, which is even smart enough to support interpolation!  For example:

    export POSTGRES_HOST="localhost"
    export POSTGRES_PORT="5432"
    export POSTGRES_USER="postgres"
    export POSTGRES_PASS="password"
    export DATABASE_NAME="gun_crawler_development"
    export POSTGRES_POOL="64"

    export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASS}@${POSTGRES_HOST}:${POSTGRES_PORT}/${DATABASE_NAME}?pool=${POSTGRES_POOL}"

This was extremely useful for me to use in some CI scripts, so I personally use the bash-flavored syntax.

#### Use --env-file in production

In production, these environment variables should go in a flat file (with appropriate permissions, only visible to your deployment user) which you reference using `docker run --env-file`.

This way, if you need to run a one-off container like a Rails console or a cron job, you can just run `docker run --rm --env-file /home/deploy/.secrets your_app` without having to copy and paste a huge list of variables to the command-line (which is also insecure as they would show up in the host process manager).

#### Bonus: delete database.yml

Incidentally, switching to an environment variable-oriented configuration means that you can delete `config/database.yml` completely. You don't need it.  Rails supports a `DATABASE_URL` environment variable (which I've given an example of above) which you should set instead. Add it to your `Envfile`, `.env`, and `.env.test` files.

### Use Makefiles to simplify building/pushing

As I introduced in my CI post, I like to put a Makefile in all of my Docker projects so that I don't have to remember the name of the registry or the Docker image name for the project I'm on.  I can simply do `make build`, `make push`, `make pull`, etc.

Here's an example Makefile from my current side project:

```
REGISTRY ?= tutum.co
PROJECT  ?= guncrawler/gun_crawler_web
TAG      ?= latest

ifdef REGISTRY
  IMAGE=$(REGISTRY)/$(PROJECT):$(TAG)
else
  IMAGE=$(PROJECT):$(TAG)
endif

.PHONY: all
all:
	@echo "Available targets:"
	@echo "  * build - build a Docker image for $(IMAGE)"
	@echo "  * pull  - pull down previous docker builds of $(IMAGE)"
	@echo "  * push  - push $(IMAGE) to remote registry"
	@echo "  * test  - build and test $(IMAGE)"

.PHONY: build
build:
	docker build -t $(IMAGE) .

.PHONY: pull
pull:
	docker pull $(IMAGE) || true

.PHONY: push
push:
	docker push $(IMAGE)

.PHONY: test
test: build
	fig -f fig.test-ci.yml run web ./test.sh
```

### Build and test on a CI service

You should set up a CI service which builds your image for production, runs tests against it, and if the tests pass, push the built image to a Docker registry for deployment to QA or production.

I've [documented how I use CircleCI][rails-docker-ci] to accomplish this in a previous blog post.

## Deployment - Ansible

Finally, the interesting part!  Now that you've got a golden master Docker image built, how do you deploy it?

My favorite tool for orchestrating deployments is Ansible.  It really excels at traditional VM provisioning (which I still use for Postgres, Redis, Elasticsearch), but getting it to work nicely with a Docker workflow was slightly challenging.  That said I still think it's the best option for this style of deployment.

Ansible's main strength is its simplicity.  Tools like Chef, Puppet, Salt require you to bootstrap provisioned servers by first installing a special daemon process on the server before you can do anything with it.  They also require you to setup a "master" server which other (slave) servers will be constantly polling for changes from.  They can also get fancy and run tasks out-of-order (Salt can, anyway).

Meanwhile Ansible only requires the remote server to have SSH and Python installed (no special daemon bootstrapping required), and rather than having servers poll from a special master, you just "push" your desired changes directly from your developer machine's playbooks ("playbooks" are Ansible's jargon for Ansible's deployment/provisioning recipes).  It also runs tasks imperatively (in the exact order specified) rather than out-of-order, which can make it a lot easier to debug in my opinion.

I don't want to turn this into a full-fledged Ansible tutorial, so I will just mention some decisions that I made.

### Ansible project structure

Ansible is written in Python, however it uses YAML files to define most of the things

TODO

```
├── bootstrap
│   └── roles
│       └── bootstrap
│           ├── files
│           │   └── public_keys
│           ├── handlers
│           └── tasks
├── deploy
├── provision
│   └── roles
│       ├── common
│       │   ├── files
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       ├── docker
│       │   ├── files
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       │       └── upstart
│       ├── elasticsearch
│       │   ├── files
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       │       ├── elasticsearch
│       │       └── nginx
│       │           └── sites-available
│       ├── gun_crawler_web
│       │   ├── tasks
│       │   └── templates
│       ├── haproxy
│       │   ├── files
│       │   │   └── certificates
│       │   │       └── staging
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       ├── job
│       │   ├── tasks
│       │   └── templates
│       │       └── upstart
│       ├── postgres
│       │   ├── files
│       │   │   ├── certificates
│       │   │   └── cron
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       │       ├── env
│       │       └── postgres
│       ├── redis
│       │   ├── files
│       │   ├── handlers
│       │   ├── tasks
│       │   └── templates
│       └── web
│           ├── files
│           │   └── certificates
│           │       └── staging
│           ├── tasks
│           └── templates
│               ├── nginx
│               └── upstart
└── staging
    └── group_vars
```

#### staging (inventory file)

The staging directory contains the inventory file and variables for my `staging` environment.  Once I go to production I will also create a `production` environment.

#### bootstrap

The bootstrap playbook is ran one time on a brand new DigitalOcean droplet which only has root access.  It creates the `deploy` user with sudo access, which I use for running the rest of my playbooks.

```
ansible-playbook -i staging/inventory bootstrap/bootstrap.yml --extra-vars="ansible_ssh_user=root"
```

#### provision

The provision directory stores my playbooks for provisioning various servies - Web servers, Postgres, Redis, HAProxy, Elasticsearch.  These playbooks set up firewalling between hosts and install and configure required services.  They are idempotent and will only restart services when needed (e.g. when configuration has changed).

Provision everything:

```
ansible-playbook -i staging/inventory provision/all.yml --sudo --ask-sudo-pass
```

Provision individual things can be done by just running the individual playbook, e.g. for Web servers:

```
ansible-playbook -i staging/inventory provision/webservers.yml --sudo --ask-sudo-pass
```

#### deploy

The deploy directory contains playbooks doing rolling updates of the Web servers and job servers (Sidekiq and Que).

I also put one-off tasks in there, like reindexing Elasticsearch.

These are not idempotent.

### Encrypting secrets using git-crypt

Ansible ships with a feature called [Vault][ansible-vault] which is meant for encrypting Ansible files that contain secrets (like passwords) that you wouldn't want someone to see if they cloned the repository that contains your deployment playbooks.  Unfortunately I have to advise completely avoiding it.

Vault is kludgy because it doesn't support encrypting arbitrary files; it can only encrypt Ansible-specific files like var files and task files. That works for simple things like passwords but when you have entire secret files that need to be encrypted, such as SSL private keys, you don't want to start cramming them into your vars files ([although some people do][ansible-vault-vars-files]).  But don't be surprised when you run into weird quirks like [whitespace issues][ansible-vault-whitespace] as you are effectively re-encoding the file inside of YAML and dealing with Ansible's unique parsing thereof.

Vault also modifies your deployment workflow by making you pass `--ask-vault-pass` or `--vault-password-file` when running playbooks.

I've found it much simpler to use a tool called [git-crypt][], which cleverly integrates with git's attributes system to transparently encrypt files when committing, but keeping them unencrypted in your working copy.  This way is much simpler as Ansible doesn't have to know that my files are encrypted; I can make full use of all the file-related Ansible modules (like copy or template) and regular command-line arguments when deploying.

### Logging - use centralized logging and logspout

[Logspout][logspout] is a Docker image created by Jeff Lindsay that taps into the Docker daemon's log files, forwarding them on to a remote syslog.  In this way you can ship the logs of all Docker containers running on a host to a remote syslog like Papertrail (that's the service I use).

Docker 1.7 launched with special support for logging drivers and an implementation of a syslog logger, but it isn't clear to me yet whether it replaces logspout's functionality yet or not.  Logspout has been working well for me so I don't need a reason to try it out yet (let me know if you know, though).

### Clean up orphaned Docker images

Docker will happily completely fill up your hard drive with orphaned Docker images (that is, Docker image layers that are not reachable via any image tag).  This will slowly happen over time as you do deployments and continually pull down new image layers and move the image tag pointer.

To fix this, I advise either adding a cron job or a post-run step in your deployment script that cleans up the orphaned images:

```
docker rmi $(docker images -f "dangling=true" -q)
```

Note that running the above cleanup command at the same time as a `docker pull` will cause issues, since when you do a pull you are pulling untagged image layers so you will be deleting them concurrently.

#### Aside: stopped containers filling up disk

There is a similar problem with Docker filling up the hard drive with stopped containers, which can be cleaned up with:

```
docker rm $(docker ps -a -q)
```

However, there is a problem with this that I very rarely see mentioned: **this will delete your data-only containers!**  If you're not familiar with data-only containers, they're the pattern advised to maintain a persistent volume, for e.g. persisting your database data blobs.  So if you delete that then your database is effectively gone - not something you want to risk fat-fingering.  Therefore the above command is something that I recommend never running.

I instead advise only deleting containers by hand or specific ones by name (e.g. during your deployments).  You should also always pass `--rm` to `docker run` when running one-off containers so they are immediately deleted when exited.  If you follow this pattern you should avoid having any cruft build up in `docker ps -a`.

At one point there was a feature request for container "pinning" that was going to solve the problem of accidentally deleting important stopped containers, but Solomon preferred a more generic approach of labelling containers.  It looks like labels have since landed (I think), but I don't immediately see how to use them to prevent the above problem (comments welcome).

### Known problems

* first deploy of Docker containers; `deploy` user added to `docker` group doesn't take effect until the second run (SSH session needs to be re-established)
* full turnaround of a code change => deployment is kinda slow when using CI (CircleCI is slow at running tests). the compilation cost of statically typed languages with none of the type safety! for a rapid deploy (e.g. emergency bug fix), building Docker image locally + pushing to tutum registry is fastest





## Future

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/abevoelker">@abevoelker</a> you have to be more diligent in finding an orchestration layer. This is why I like mesos.</p>&mdash; Bryan Liles (@bryanl) <a href="https://twitter.com/bryanl/status/576145224109568000">March 12, 2015</a></blockquote>

3 months later...

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Pretty wowed by Mesos (+ Marathon, Chronos, DCOS). Very polished and great docs. Will be interesting to see what it all means for VPS usage.</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/610976220709285888">June 17, 2015</a></blockquote>

2 hours later...

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Sadly Marathon doesn&#39;t have a way to do compose multiple containers a la CoreOS/Fleet sidekicks or Kubernetes pods <a href="https://t.co/3dgBnfGrJj">https://t.co/3dgBnfGrJj</a></p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/611008561473302528">June 17, 2015</a></blockquote>


(TODO insert Mesos allocation vs VMs slide)


### Orchestrators that fail my needs

I currently can fail the use of most orchestrators for my needs by asking three simple questions:

1. Is it production-ready?
2. Does it support linked containers?
3. Does it support one-off interactive consoles (e.g. `rails console`)?

Mesos/Marathon

* can't run linked containers
* doesn't support interactive containers (rails console)

Kubernetes

* not production-ready

CoreOS

* not production-ready

Deis (uses CoreOS)

* doesn't support interactive containers (https://github.com/deis/deis/issues/117)


For my own application, I could see myself eventually moving to Mesos once that settles a bit.  Especially considering the nice dashboard with the health checks and Chronos for scheduling jobs.

It will be interesting to see how use of Docker evolves.  I used to tell myself that once enough Docker images get written to cover popular services, Docker might really take off.  But Docker is two years old now and there are a lot of Docker images out there covering the popular stuff; there seems to be something else holding it back.  Perhaps it's the lack of maturity in the cluster deployment tools like Mesos, Kubernetes, CoreOS et al.

It will also be interesting to see how other developments in application deployment affect Docker.  The rise of functional package managers like Nix and GNU Guix might cure enough of a pain point for many applications that Docker is not necessarily worth it.  Or perhaps [unikernels][] will become more feasible for more programming environments than OCaml, Erlang, and Haskell.




## References

* [Ansible environment layout inspiration][ansible-layout-inspiration]



[rails-development-docker]: /rails-development-using-docker-and-vagrant
[rails-docker-ci]:          /simple-free-continuous-integration-of-rails-docker-images-using-fig-make-and-circleci
[why-i-dont-use-docker]:    /why-i-dont-use-docker-much-anymore
[simplest-thing]:           http://c2.com/cgi/wiki?DoTheSimplestThingThatCouldPossiblyWork

[GunCrawler]:               https://guncrawler.com
[bind-mount-madness]:       https://groups.google.com/forum/#!topic/docker-user/oLAvgbrcw2A
[launchy]:                  https://github.com/copiousfreetime/launchy
[letter_opener]:            https://github.com/ryanb/letter_opener
[letter_opener_web]:        https://github.com/fgrehm/letter_opener_web
[save_and_open_page]:       http://shorts.jeffkreeftmeijer.com/2010/open-the-browser-with-capybaras-save_and_open_page/
[web-console]:              https://github.com/rails/web-console
[better_errors]:            https://github.com/charliesome/better_errors
[gold-master]:              http://en.wikipedia.org/wiki/Software_release_life_cycle#RTM
[baseimage-docker]:         https://github.com/phusion/baseimage-docker


[dotenv]:                   https://github.com/bkeepers/dotenv
[12factor]:                 http://12factor.net/config
[ansible-vault]:            http://docs.ansible.com/playbooks_vault.html
[ansible-vault-vars-files]: http://stackoverflow.com/a/22775066/215168
[ansible-vault-whitespace]: https://github.com/ansible/ansible/issues/9556
[git-crypt]:                https://github.com/AGWA/git-crypt
[logspout]:                 https://github.com/gliderlabs/logspout


[docker-deadlock]:          https://github.com/docker/docker/issues/8909


[horizontal-scaling]:       http://en.wikipedia.org/wiki/Scalability#Horizontal_and_vertical_scaling
[libswarm]:                 https://github.com/docker/libswarm
[mesos-slides]:             http://www.slideshare.net/dotCloud/high-speed-shipping-lanes-how-containers-are-revolutionizing-distributed-computing-at-scale
[mesos-talk]:               https://www.youtube.com/watch?v=F1-UEIG7u5g
[linode-incidents]:         http://en.wikipedia.org/wiki/Linode#Security_concerns
[linode-backups]:           https://www.linode.com/docs/platform/backup-service#how-linode-backups-work

[ha]:                       http://en.wikipedia.org/wiki/High-availability_cluster


[cache-is-the-new-ram]:     http://blog.memsql.com/cache-is-the-new-ram/
[baseimage-docker]:         http://phusion.github.io/baseimage-docker/
[baseimage-docker-wrong1]:  http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
[baseimage-docker-wrong2]:  https://news.ycombinator.com/item?id=7950326
[docker-uid-madness]:       https://groups.google.com/forum/#!topic/docker-user/oLAvgbrcw2A


[postgres-xc]:              http://postgresxc.wikia.com/wiki/Postgres-XC_Wiki


[ansible-layout-inspiration]: https://medium.com/@Drew_Stokes/ansible-good-for-the-environment-6ed26dc0e06e




[heroku-dev-prod-parity]: https://devcenter.heroku.com/articles/deploying-to-a-custom-rails-environment#summary
[envied]:                 https://github.com/eval/envied
[pliny-config]:           https://github.com/interagent/pliny/blob/daadf41bdbc887472c403f701c77aa9fd9a625b9/lib/template/config/config.rb


[unikernels]: https://medium.com/@darrenrush/after-docker-unikernels-and-immutable-infrastructure-93d5a91c849e
