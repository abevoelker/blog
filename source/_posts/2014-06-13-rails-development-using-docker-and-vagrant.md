---
layout: post
title: "Rails Development Using Docker and Vagrant"
date: 2014-06-13 16:00
comments: true
categories:
---

[{% img center /images/docker.png Docker containerizing some typical Rails-stack software %}](/images/docker.png)

If you're like me, you've probably been hearing a lot about [Docker][docker] over the past year but haven't really gotten past the ["hello world" tutorial][docker-tutorial] because you haven't found a good way to integrate it into your development workflow or staging/production deployment process.  I've spent the last several weeks learning Docker and porting a Rails project's development environment from Ansible provisioning to Docker, so I thought I'd share my experiences so far.

<!-- more -->

## Why Docker?

Until recently I had been pretty happy with my development provisioning setup, which consisted of [Vagrant][vagrant] for spinning up development machines and [Ansible][ansible] playbooks for provisioning the software I needed installed on them.  Eventually, after getting sick of the slowness of virtual machines (Vagrant's default provider is VirtualBox), I switched to the excellent [vagrant-lxc][vagrant-lxc] plugin, which allowed Vagrant to provision lightweight Linux containers ([LXC][lxc]) instead of VMs.

There's just something so satisfying about typing `vagrant up` and watching machines get spun up by Vagrant, and then seeing the green Ansible statuses slowly scroll by as the playbooks install the necessary software and libraries to run my code.  Well, it's satisfying unless I'm in a hurry and don't want to wait 10+ minutes for all the machines to get provisioned.  Or when I come back to a project months later and hit a red status due to a piece of the playbook now being broken.  Or, in a deployment scenario, where I have to worry about external sources being unavailable (APT repositories, GitHub, RubyGems.org) or dependencies mutating between development testing and deployment time (e.g. new versions of APT packages becoming available, causing differing package versions to get installed on production).

Docker solves a lot of these problems.  It simplifies development by making it fast and easy to spin up containers that are exact filesystem-level snapshots of production, typically differing only by environment variables or by config file difference (via mounted [volumes][docker-volumes]).  This same snapshotting mechanism makes it much less nerve-wracking to deploy to staging or production as well, as you are deploying the full snapshot at once.  You don't have to cross your fingers while APT updates packages, git does checkouts, or Bundler updates gems from RubyGems.org.  Everything is already there in the Docker image.

Docker is especially appealing to me in the context of Rails deployments, since you have to do other things like compile assets for the asset pipeline or upgrade the Ruby interpreter version - things that are annoying to try and write in Capistrano or Ansible.

<div class="alert-message" markdown="1">
**Note**: You may have heard of the ["vendor everything"][vendor-everything] approach to bundling gems for deployment, which advocates checking gem binaries into your source control.  The benefit to that approach is that you no longer have to worry about RubyGems.org (or other gem sources) being down when you do deploys.  The downside is that you add bloat to your source control by storing big fat binary files in it.  Docker gives you the same benefit without corroding your source control.  Win!
</div>

## Creating Docker images: the Dockerfile

<div class="alert-message" markdown="1">
**Terminology note**: I was going to start by including my own simplified definitions of what Docker [images][docker-image] and [containers][docker-container] are, but the Docker website does a great job with these terms so check the links intead.
</div>

When creating your own Docker images, you will define the build instructions via a Dockerfile.  A Dockerfile is a list of statements, executed imperatively, that follow [a special DSL syntax][dockerfile-syntax].  Each statement in the Dockerfile generates a new image that is a child of the preview statement's image.  You know what that creates?  A [directed acyclic graph (DAG)][dag] of images, not at all unlike a [graph of git commits][git-dag]:

[{% img center /images/docker-dag.png Graph of docker images on my machine %}](/images/docker-dag.png)

<div class="alert-message" markdown="1">
**Note**: Each blue node in the graph above has a tag, very similar to a branch or tag in a git commit graph. This graph was generated with `docker images --viz | dot -Tpng -o docker.png`, if you want to look at the graph of Docker images on your machine. You can also see the graph in your console directly with `docker images --tree`
</div>

When building Docker images, Docker takes advantage of this structure to do caching.  Each statement in a Dockerfile may be cached, and if the cache for that statement is invalidated, all of the child images (the proceeding Dockerfile statements) will need to be rebuilt as well.

As you may notice from the graph, when writing a Dockerfile it's common to descend from an image (using the [`FROM` statement][dockerfile-from]) of a Linux flavor that you are familiar with.  I use `ubuntu:trusty` as it's what I'm familiar with - mainly so that I can use APT and custom PPAs to install packages.  You can think of it in the context of Ruby as a sort of "subclass"-type inheritance.

If you get into Docker right now, expect to create your own Dockerfiles for services you need as there seems to be a dearth of good, easily reusable ones out there.  When I was starting this post, you had to do a lot of digging through the [Docker registry][docker-registry] (formerly called the Docker Index) to find images to use (and you couldn't even sort by stars!).  So I've had to spend a lot of time porting over my own Ansible playbooks, which you can find on [my Docker Hub page][my-docker-hub].

Now that they've [launched "Docker Hub,"][docker-hub-launch] they have some images tagged as "official."  However, some of these "official" images don't make it easy to see exactly how they are building the images (e.g. the [official Postgres image][official-postgres-image]), so I would steer clear for now.  I imagine now that they've made it easier to use we will see some better images come out soon.

## An example Rails app Dockerfile

Here's an example Dockerfile of a Rails application that I'm working on right now:

```
FROM       abevoelker/ruby
MAINTAINER Abe Voelker <abe@abevoelker.com>

# Add 'web' user which will run the application
RUN adduser web --home /home/web --shell /bin/bash --disabled-password --gecos ""

# Separate Gemfile ADD so that `bundle install` can be cached more effectively
ADD Gemfile      /var/www/
ADD Gemfile.lock /var/www/
RUN chown -R web:web /var/www &&\
  mkdir -p /var/bundle &&\
  chown -R web:web /var/bundle
RUN su -c "cd /var/www && bundle install --deployment --path /var/bundle" -s /bin/bash -l web

# Add application source
ADD . /var/www
RUN chown -R web:web /var/www

USER web

WORKDIR /var/www

CMD ["bundle", "exec", "foreman", "start"]
```

I'll break up each piece and talk about it separately:

### FROM

```
FROM abevoelker/ruby
```

As mentioned above, the [`FROM` statement][dockerfile-from] allows you to effectively chain your Dockerfile statements onto the end of a parent image.  In this example, I am starting from an image I had created called [`abevoelker/ruby`][abevoelker-ruby], which at the moment is tuned for my own use rather than reusability for others.  You can check out [the source code][abevoelker-ruby-github] to see the goodies it contains (namely the latest MRI Ruby, nginx, git, a Postgres client, and Node.js for better execjs performance).

### MAINTAINER

```
MAINTAINER Abe Voelker <abe@abevoelker.com>
```

[`MAINTAINER`][dockerfile-maintainer] sets the author metadata in the generated image.  It's just a nicety for people who might grab your image - not required.

### ADD Gemfile and Gemfile.lock

```
ADD Gemfile      /var/www/
ADD Gemfile.lock /var/www/
RUN chown -R web:web /var/www &&\
  mkdir -p /var/bundle &&\
  chown -R web:web /var/bundle
```

[`ADD`][dockerfile-add] copies files from where the Dockerfile is being built into the resulting image.  `ADD` does not accept wildcards, so one cannot do `ADD Gemfile*`.

[`RUN`][dockerfile-run] executes commands in a new container.  You will note that I am immediately `chown`ing the files to my `web` user, because `ADD` gives the file root ownership (you will see this pattern a lot in Dockerfiles).

<div class="alert-message" markdown="1">
**ADD gotcha**: One thing that had tripped me up with `ADD` is that you cannot add files that exist above the Dockerfile's directory.  So you cannot do `ADD ../some_file`.  There is a note on the [`ADD` reference page][dockerfile-add] if you want the technical details as to why.
</div>

### bundle install

```
RUN su -c "cd /var/www && bundle install --deployment --path /var/bundle" -s /bin/bash -l web
```

This `RUN` statement generates the bundle that the Rails app will utilize.  Note that I am storing the bundle in `/var/bundle`, outside of the application source directory where I put the Gemfiles earlier (`/var/www`).  I'll explain that shortly.

### ADD application source

```
ADD . /var/www
RUN chown -R web:web /var/www
```

The full source of the Rails application gets added to `/var/www`.  The reason this happens below the earlier Gemfile ADDs and the `bundle install` is twofold:

1. `ADD . /var/www` will constantly be breaking the `docker build` cache, since *any file change* in the application's directory will do it - even changing the Dockerfile itself. We don't want to have to reinstall our gems every time we change a file - only if the Gemfile or Gemfile.lock changes.
2. `ADD . /var/www` will overwrite every file in `/var/www`.  If we did our `bundle install` to this same destination directory before `ADD`, the bundle would have been wiped out.  Therefore, I store the bundle in `/var/bundle` and the application source in `/var/www`.

### USER

```
USER web
```

[`USER`][dockerfile-user] sets the user that all proceeding `RUN` statements will execute with, as well as the user that runs the image.

### WORKDIR

```
WORKDIR /var/www
```

[`WORKDIR`][dockerfile-workdir] sets the working directory for proceeding `RUN`, `CMD`, and `ENTRYPOINT` statements. I sometimes use it as a convenience so that I don't have to dirty up the `CMD` statement with `cd`.

### CMD

```
CMD ["bundle", "exec", "foreman", "start"]
```

[`CMD`][dockerfile-cmd] sets the default command that the image will run when started.  You can have multiple `CMD` statements; the last one takes precedence (in this way inheriting images can override their parents).

When running an image, you can override its baked-in `CMD` with your own command. For example, `docker run -i -t ubuntu:trusty /bin/bash`.

My example `CMD` statement starts `foreman`, which is adequate for development.  It would probably be better to move each service in the foreman Procfile to their own [supervisord][supervisord] configs, and have this `CMD` statement start up supervisord instead of foreman. Such an approach is common for running multiple processes in a Docker container and is production-safe.

<div class="alert-message" markdown="1">
**Note**: I mentioned that it is common to use supervisord to start up multiple processes in a Docker container.  It is very important to note that Docker is *not like a VM* - the Docker container will only run the exact process that you tell it to run (that process in turn can spawn other processes).  But there is no init process, no cron daemon, no SSH daemon, etc.  It took me a little bit to understand this.

There is [an image out there by Phusion][phusion-base-image] that aims to replicate a basic running Linux system, but it seems to be frowned upon by the Docker devs I've seen in #docker as it goes against the intent of Docker and it can have wonky issues (for example, upstart scripts may behave weirdly due to not getting the correct signals they need to start).

It is also important to note that the process you start with your Docker container must run in the foreground, or Docker will think the container halted.  Thus **do not** try to use /etc/init.d scripts as `CMD` arguments (instead, look at what those scripts are doing and unroll the daemonization).
</div>

## An example Vagrantfile using the Docker provisioner

{% img left /images/vagrant-logo.png 250 300 Vagrant logo %}

Vagrant 1.6 added support for Docker providers and provisioners.  I've seen some people say that this will make it easier for people to learn Docker, but I disagree.  [Vagrant's Docker provider DSL][vagrant-docker-config] is a pretty thin façade over the Docker CLI, so you need to have a good handle on how Docker works before using it - otherwise you're just dealing with another layer of indirection which will make things more confusing!

Anyway, here's a Vagrantfile from a Rails app I'm working on called `gun_crawler_web` that corresponds to the Dockerfile from above:

<div style="display: inline-block;" markdown="1">
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "postgres" do |postgres|
    postgres.vm.provider 'docker' do |d|
      d.image  = 'abevoelker/postgres'
      d.name   = 'gun_crawler_web_postgres'
      d.expose = [5432]
    end
  end

  config.vm.define "elasticsearch" do |elasticsearch|
    elasticsearch.vm.provider 'docker' do |d|
      d.image  = 'dockerfile/elasticsearch'
      d.name   = 'gun_crawler_web_elasticsearch'
      d.expose = [9200]
      d.cmd    = ['/elasticsearch/bin/elasticsearch', '-Des.config=/data/elasticsearch.yml']
      d.env    = {
        'ES_USER'      => 'elasticsearch',
        'ES_HEAP_SIZE' => '512m'
      }
    end

    elasticsearch.vm.synced_folder "docker/elasticsearch", "/data"
  end

  config.vm.define "redis" do |redis|
    redis.vm.provider 'docker' do |d|
      d.image  = 'dockerfile/redis'
      d.name   = 'gun_crawler_web_redis'
      d.expose = [6379]
      d.cmd    = ['redis-server', '/data/redis.conf']
    end

    redis.vm.synced_folder "docker/redis", "/data"
  end

  config.vm.define "web" do |web|
    web.vm.provider 'docker' do |d|
      d.image           = 'abevoelker/gun_crawler_web'
      d.name            = 'gun_crawler_web'
      d.create_args     = ['-i', '-t']
      d.cmd             = ['/bin/bash', '-l']
      d.remains_running = false

      d.link('gun_crawler_web_postgres:postgres')
      d.link('gun_crawler_web_elasticsearch:elasticsearch')
      d.link('gun_crawler_web_redis:redis')
    end

    web.vm.synced_folder ".", "/var/www", owner: 'web', group: 'web'
  end
end
```
</div>

As you can see, this configuration defines four containers that make up my application.  One for Postgres, one for Redis, one for Elasticsearch, and of course one for my Rails application.

Let's look at each config section so we can understand what's going on.

### Postgres container

```
config.vm.define "postgres" do |postgres|
  postgres.vm.provider 'docker' do |d|
    d.image  = 'abevoelker/postgres'
    d.name   = 'gun_crawler_web_postgres'
    d.expose = [5432]
  end
end
```

The first line:

```
d.image  = 'abevoelker/postgres'
```

is obviously referencing the image that will be used to start the container.  If the image doesn't exist locally (if you didn't `docker build -t` or `docker pull` it), then it will be pulled down from the Docker registries you have defined (by default, docker uses the public [Docker Hub][docker-registry] registry).

```
d.name   = 'gun_crawler_web_postgres'
```

This assigns a unique name to the container.  This is a convenience so that when you are using the Docker CLI, you don't have to use the hash ID to reference it.  This will be important later to the Rails application container definition.

```
d.expose = [5432]
```

This exposes the container's 5432 port locally.  The **only reason** I do this is so I can use pgAdmin on my host machine to inspect the development database.  I **do not need** to expose the port in order to connect to it from the Rails application (as I'll show later).

#### Equivalent Docker CLI

Remember when I said Vagrant was a thin façade over the Docker CLI?  If you didn't have Vagrant, you can easily run the container yourself the same way via the Docker CLI:

```
docker run -d -name gun_crawler_web_postgres -p 5432:5432 -t abevoelker/postgres
```

<div class="alert-message" markdown="1">
**Note**: To list all containers running on your host machine, use `docker ps`.  To list *all* containers (included stopped ones), use `docker ps -a`.
</div>

### Elasticsearch container

```
config.vm.define "elasticsearch" do |elasticsearch|
  elasticsearch.vm.provider 'docker' do |d|
    d.image  = 'dockerfile/elasticsearch'
    d.name   = 'gun_crawler_web_elasticsearch'
    d.cmd    = ['/elasticsearch/bin/elasticsearch', '-Des.config=/data/elasticsearch.yml']
    d.env    = {
      'ES_USER'      => 'elasticsearch',
      'ES_HEAP_SIZE' => '512m'
    }
  end

  elasticsearch.vm.synced_folder "docker/elasticsearch", "/data"
end
```

The new config options are:

```
elasticsearch.vm.synced_folder "docker/elasticsearch", "/data"
```

As you can imagine, this mounts the local `docker/elasticsearch` directory into the container as `/data` (this is a Docker volume).  A common use case for this is if you have a configuration file you need to make available to the service.

```
d.cmd    = ['/elasticsearch/bin/elasticsearch', '-Des.config=/data/elasticsearch.yml']
```

This is the command used to start the image (it overrides the image's default `CMD`). Note we are passing it a configuration file that exists in the `/data` volume we mounted.


```
d.env    = {
  'ES_USER'      => 'elasticsearch',
  'ES_HEAP_SIZE' => '512m'
}
```

As you can guess, we set the `$ES_USER` and `$ES_HEAP_SIZE` Unix environment variables to custom values.

#### Equivalent Docker CLI

```
docker run -d -v docker/elasticsearch:/data -name gun_crawler_web_elasticsearch --env ES_USER=elasticsearch --env ES_HEAP_SIZE=512m -t dockerfile/elasticsearch /elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml
```

### Redis container

```
config.vm.define "redis" do |redis|
  redis.vm.provider 'docker' do |d|
    d.image  = 'dockerfile/redis'
    d.name   = 'gun_crawler_web_redis'
    d.cmd    = ['redis-server', '/data/redis.conf']
  end

  redis.vm.synced_folder "docker/redis", "/data"
end
```

Nothing new here.

#### Equivalent Docker CLI

```
docker run -d -v docker/redis:/data -name gun_crawler_web_redis redis-server /data/redis.conf
```

### Rails application container

```
config.vm.define "web" do |web|
  web.vm.provider 'docker' do |d|
    d.image           = 'abevoelker/gun_crawler_web'
    d.name            = 'gun_crawler_web'
    d.create_args     = ['-i', '-t']
    d.cmd             = ['/bin/bash', '-l']
    d.remains_running = false

    d.link('gun_crawler_web_postgres:postgres')
    d.link('gun_crawler_web_elasticsearch:elasticsearch')
    d.link('gun_crawler_web_redis:redis')
  end

  web.vm.synced_folder ".", "/var/www", owner: 'web', group: 'web'
end
```

```
d.image           = 'abevoelker/gun_crawler_web'
```

This is not a new option, however I want to point out that I actually prefer to build the image manually rather than let Vagrant do it. Why? Because on my machine I don't see the Docker build output when Vagrant does it - I just get a black screen until it is all finished, which is not very useful when developing.

So before I do `vagrant up`, I build my Rails application Docker image locally with `docker build -t "abevoelker/gun_crawler_web" .`.

```
d.create_args     = ['-i', '-t']
```

These are extra arguments passed to `docker run`.  These arguments ensure that the container is ran interactively, so that we can attach to the shell properly (more on that later).

```
d.remains_running = false
```

Vagrant apparently errors if the container stops; since we will be occasionally halting the container when we detach from it we don't want Vagrant to throw a fit.

```
d.link('gun_crawler_web_postgres:postgres')
d.link('gun_crawler_web_elasticsearch:elasticsearch')
d.link('gun_crawler_web_redis:redis')
```

This is an extremely important concept called [container linking][container-linking].  We link the previous three containers into the application container, which allows the application container to access the exposed ports and see environment variables of the linked containers.  When linking, the form is `linked_container_name:alias`.  The alias bit is important because environment variables exposed in the container will be prefixed with the alias name.

For example, in order to connect to the Postgres database using the above linking definition, I've modified my `config/database.yml` file like so (it takes advantage of Rails evaluating ERB in this file):

```yaml
# config/database.yml
postgres_defaults: &postgres_defaults
  adapter:   postgresql
  encoding:  utf8
  # fixes UTF8 encoding issue when trying to use template1
  template:  template0
  ctype:     en_US.utf8
  collation: en_US.utf8
  port:      5432
  host:      <%= ENV['POSTGRES_PORT_5432_TCP_ADDR'] %>
  username:  <%= ENV['POSTGRES_ENV_USERNAME'] %>
  password:  <%= ENV['POSTGRES_ENV_PASSWORD'] %>
  pool:      5

development:
  <<: *postgres_defaults
  database: gun_crawler_development

test:
  <<: *postgres_defaults
  database: gun_crawler_test
```

`$POSTGRES_ENV_USERNAME` and `$POSTGRES_ENV_PASSWORD` are generated by Docker from environment variables exposed in the `abevoelker/postgres` image Dockerfile (via `ENV USERNAME` / `ENV PASSWORD`).

`$POSTGRES_PORT_5432_TCP_ADDR` is automatically generated by Docker from the exposed ports defined in the `abevoelker/postgres` image Dockerfile (via `EXPOSE 5432`).

```
d.cmd             = ['/bin/bash', '-l']
```

This isn't a new option, but note that we are running bash rather than the Rails server or foreman.  Basically, after I do `vagrant up`, I then run `docker attach gun_crawler_web`, and that attaches me to this interactive bash shell (note you might have to hit enter after running that command to redraw the shell).

From here I'm free to run whatever commands one normally runs when in development, like `rake db:setup`, `rake db:migrate`, `rails c`, `rails s`, etc.  I think this is a lot better way of doing things than spawning a bunch of different containers for every little command, which I've seen some tutorials do.

### Equivalent Docker CLI

```
docker build -t "abevoelker/gun_crawler_web" .
docker run -i -t -v .:/var/www -name gun_crawler_web --link=gun_crawler_web_postgres:postgres --link=gun_crawler_web_elasticsearch:elasticsearch --link=gun_crawler_web_redis:redis /bin/bash -l
```

## Putting it all together

So basically, from scratch, these are the commands I run from a freshly-checked-out Rails application:

```
docker build -t "abevoelker/gun_crawler_web" . # OR docker pull abevoelker/gun_crawler_web
vagrant up
docker attach gun_crawler_web
```

If there is interest, I could make a demo Rails application with a Dockerfile and Vagrantfile in a ready-to-go package for trying this out.  Let me know in the comments if that's something you'd be interested in.

## Next step: deployment

So far, I've only updated my development environment to use Docker.  I have yet to deploy to a remote staging/production environment.  I have some ideas, but have yet to try them out.

Therefore my next article will be focused on Rails deployment using Docker.  I plan on primarily using Ansible for this, using [its Docker module][ansible-docker].

Some questions/notes I have to think about:

* How to ensure container volumes persist - use linked persistent containers or expose host filesystem?
* Is there a good way to handle rollbacks, à la Capistrano's `cap deploy:rollback`?
* Some things will still need to be done in a deploy playbook besides managing Docker containers, e.g. `rake db:migrate`
* What makes a good host system OS - would it make sense to use CoreOS? Can we benefit from etcd and confd?
* Is there a good way to do zero-downtime deploys without adding excessive complexity?

## Addendum: Docker gotchas

<blockquote class="twitter-tweet" lang="en"><p>And now VOLUME is giving me the middle finger on permissions. Surprising how fickle Docker is for how supposedly close to 1.0 it is.</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/statuses/472744820453441536">May 31, 2014</a></blockquote>

When I first started with Docker, I was kind of surprised to run into some issues and rough edges since I was using the 1.0 release candidate (0.10).  However, the Docker team (and other people) have been very responsive in IRC (#docker on Freenode), GitHub issues, and even just picking up mentions of Docker on Twitter.  If you run into any issues they will help you or get it fixed straight away.

Some issues or surprises I've ran into that might be useful to you:

* When building a lot of images locally, Docker consumes a lot of disk space by leaving orphaned images (see graph above) and stopped containers around.  I actually ran out of disk space a couple times due to this (it was using 46GiB at the time).  From idling the #docker IRC a while, this isn't an uncommon problem for people to have.  It would be nice if there was an equivalent to git's `git gc` to clean up orphaned images, but until then the workarounds are to periodically:
  * Delete untagged images with `docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')`
  * Delete stopped containers with `docker rm $(docker ps -a -q)`
* The `USER` statement in a Dockerfile *does not* apply to `ADD` statements that follow it - `ADD` always sets the file owner to root.
  * If you want to `ADD` files that should belong to a specific user, you should put the `ADD` statement above the `USER` statement and immediately follow it with a `RUN chown` statement to modify the ownership.
  * There is an [open issue][docker-add-issue] on this (what I consider) surprising behavior, however the Docker maintainers that have responded don't seem too enthusiastic on changing it.
* Each `RUN` statement in a Dockerfile runs in a different container than the previous one.  Therefore, you cannot do something like `RUN /etc/init.d/some-service` and then on the next line have another `RUN` statement that expects that service to be running.  I ran into this with [my Postgres image][abevoelker-postgres].  The simple solution is just to chain the statements with `&&` (e.g. `RUN /etc/init.d/some-service && your-command`).  As a bonus you will create less images/containers as well when building your Dockerfile.
* On Docker 0.11 and below, there was [an issue I found][docker-volume-issue] with `VOLUME` changing permissions on exposed directories.
  * This has been fixed in 0.12, so if you are on the latest Docker you won't run into this.

[vagrant]:                 http://www.vagrantup.com/
[docker]:                  https://www.docker.io/
[lxc]:                     http://en.wikipedia.org/wiki/LXC
[vagrant-lxc]:             https://github.com/fgrehm/vagrant-lxc
[ansible]:                 http://www.ansible.com/home
[docker-tutorial]:         https://www.docker.io/gettingstarted/
[docker-volumes]:          http://docs.docker.com/userguide/dockervolumes/
[docker-volume-issue]:     https://github.com/dotcloud/docker/issues/6137
[docker-add-issue]:        https://github.com/dotcloud/docker/issues/6119
[docker-build]:            http://docs.docker.io/en/latest/contributing/devenvironment/
[vendor-everything]:       http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/
[dockerfile-syntax]:       http://docs.docker.com/reference/builder/
[official-postgres-image]: https://registry.hub.docker.com/_/postgres/
[docker-hub-launch]:       http://blog.docker.com/2014/06/announcing-docker-hub-and-official-repositories/
[docker-registry]:         https://registry.hub.docker.com/
[my-docker-hub]:           https://hub.docker.com/u/abevoelker/
[ansible-docker]:          http://docs.ansible.com/docker_module.html
[dockerfile-from]:         http://docs.docker.com/reference/builder/#from
[dockerfile-maintainer]:   http://docs.docker.com/reference/builder/#maintainer
[dockerfile-add]:          http://docs.docker.com/reference/builder/#add
[dockerfile-run]:          http://docs.docker.com/reference/builder/#run
[dockerfile-user]:         http://docs.docker.com/reference/builder/#user
[dockerfile-workdir]:      http://docs.docker.com/reference/builder/#workdir
[dockerfile-cmd]:          http://docs.docker.com/reference/builder/#cmd
[supervisord]:             http://supervisord.org/
[abevoelker-ruby]:         https://registry.hub.docker.com/u/abevoelker/ruby/
[abevoelker-ruby-github]:  https://github.com/abevoelker/docker-ruby
[abevoelker-postgres]:     https://registry.hub.docker.com/u/abevoelker/postgres/
[dag]:                     http://en.wikipedia.org/wiki/Directed_acyclic_graph
[git-dag]:                 http://www.ericsink.com/vcbe/html/directed_acyclic_graphs.html
[docker-image]:            http://docs.docker.com/terms/image/
[docker-base-image]:       http://docs.docker.com/terms/image/#base-image
[docker-container]:        http://docs.docker.com/terms/container/
[phusion-base-image]:      http://phusion.github.io/baseimage-docker/
[vagrant-docker-config]:   http://docs.vagrantup.com/v2/docker/configuration.html
[container-linking]:       http://docs.docker.com/userguide/dockerlinks/#container-linking
