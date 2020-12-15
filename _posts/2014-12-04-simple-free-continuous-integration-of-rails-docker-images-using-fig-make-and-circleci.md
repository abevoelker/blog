---
title: "Simple, free continuous integration (CI) of Rails Docker images using fig, make, and CircleCI"
date: 2014-12-04 15:45
header:
  og_image: simple-free-continuous-integration-of-rails-docker-images-using-fig-make-and-circleci/docker-fig-make-circleci.png
toc: true
toc_label: "Sections"
toc_sticky: true
---

<h2 id="intro" style="display: none;">Introduction</h2>

{% asset "simple-free-continuous-integration-of-rails-docker-images-using-fig-make-and-circleci/docker-fig-make-circleci.png" alt="Docker, Fig, Make, and CircleCI logos" %}

This is my second post on Docker.  Previously I showed you how I [develop Rails apps locally using Docker and Vagrant][rails-development-docker] on my development machine.  I had planned to cover Rails production deployments using Docker next, but that post is not quite done as it got a lot longer than I originally intended and needs some editing.  So for now, I'm going to show how I do simple and free continuous integration (CI) using Docker, [fig][], [make][], and [CircleCI][circleci].

This setup will use CircleCI to remotely do a `docker build`, test the built image, and if the tests pass, push the image to a remote Docker registry.

I created an [example Rails repository on GitHub][example-repo] to illustrate the basic setup, and I will be using the code from there as examples in this post.  Here's the current build status of that example project on CircleCI (hopefully it's green!):

[![Circle CI](https://circleci.com/gh/abevoelker/example_rails_docker_ci.svg?style=shield)](https://circleci.com/gh/abevoelker/example_rails_docker_ci)

## Prerequisites

To follow along in running commands against the [example repo code][example-repo], you should have the following installed on your machine:

* [Docker][docker-install] (duh)
* [fig][fig-install]
* `make` (you should already have this installed on Linux/Mac)

## Describing container relationships with fig

If you're not familiar with fig, it's basically a simple way to declaratively specify the containers that you need running in a YAML format, and fig takes care of starting them up (including resolving linked container dependencies).

Here's the fig.yml from the example repo:

```yaml
web:
  image: abevoelker/example_rails_docker_ci
  links:
    - postgres
    - elasticsearch
    - redis
postgres:
  image: abevoelker/postgres
elasticsearch:
  image: dockerfile/elasticsearch
redis:
  image: redis

```

To bring up all of the containers at once, in parallel, do `fig up`.  It will give each container a unique name and log color-coded output to the console.

If there's a particular container you want to run, do `fig run <container-name>`.  This is what we will be using for our CI script because this method passes the exit code of the container that is ran through as the shell's exit code. `fig run` is smart enough to also start up any necessary linked containers (if they're not already running) defined in `fig.yml`.

## A Makefile for convenient builds and testing

I started using `Makefile`s in all my Docker projects when I got sick of writing `docker build -t someregistry/abevoelker/someproject .` over and over again (and having to remember project names when jumping around).  So the first thing I wrote was a rule for `make build` to simplify that process.

To make testing easy, we can thus add a rule for `make test`.  Here's the `Makefile` from the example repo with that rule defined:

```make
PROJECT ?= abevoelker/example_rails_docker_ci
TAG     ?= latest

ifdef REGISTRY
  IMAGE=$(REGISTRY)/$(PROJECT):$(TAG)
else
  IMAGE=$(PROJECT):$(TAG)
endif

all:
	@echo "Available targets:"
	@echo "  * build - build a Docker image for $(IMAGE)"
	@echo "  * pull  - pull $(IMAGE)"
	@echo "  * push  - push $(IMAGE)"
	@echo "  * test  - build and test $(IMAGE)"

build: Dockerfile
	docker build -t $(IMAGE) .

pull:
	docker pull $(IMAGE) || true

push:
	docker push $(IMAGE)

test: build
	fig run web ./env/test.sh ./test.sh

```

<p class="notice--primary" markdown="1">
Note: [Makefile rules][makefile-rules] require real tab characters, spaces will not parse!
</p>

Note the `test` rule has a dependency on `build`, so `make test` will ensure a fresh Docker image build (i.e. run `make build`) right before testing.  This `Makefile` also supports `REGISTRY` and `TAG` variables, so if you have a private registry to push to or want to a specific tag for a build, you can do e.g. `REGISTRY=tutum.co TAG=master make build`.

As you can see, the `make test` task runs `fig run web ./env/test.sh ./test.sh`.  I'll explain the purposes of these two scripts next.

### Environment wrapper script (./env/test.sh)

The first script is a wrapper script that exposes environment variables that the Rails app is expecting.  The reason that this is put into an executable script, rather than say using `docker run`'s `--env-file` or `-e` parameters, is that some variables are dependent on other variables' values at runtime, and so I need some kind of dynamic interpolation at container run time.

The typical reason for this need, which the example script illustrates, are the [environment variables exposed when linking containers][docker-links-env-variables]:

```bash
#!/bin/bash

export RAILS_ENV="test"

export POSTGRES_USER="${POSTGRES_ENV_USERNAME}"
export POSTGRES_PASS="${POSTGRES_ENV_PASSWORD}"
export POSTGRES_HOST="${POSTGRES_PORT_5432_TCP_ADDR}"
export POSTGRES_PORT="5432"
export DATABASE_NAME="example_rails_docker_ci_test"

export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASS}@${POSTGRES_HOST}:${POSTGRES_PORT}/${DATABASE_NAME}"
export ELASTICSEARCH_URL="http://${ELASTICSEARCH_PORT_9200_TCP_ADDR}:9200"
export REDIS_URL="redis://${REDIS_PORT_6379_TCP_ADDR}:6379/0"

# Execute the commands passed to this script
# e.g. "./env.sh bundle exec rake
exec "$@"

```

In some cases you can get away with handling this interpolation inside of the application code (for example Rails lets you evaluate ERB inside of database.yml), but I find it cleaner to use a wrapper script and not corrode the application logic.

Depending on how your image is structured, this wrapper script approach could also work nicely as an [`ENTRYPOINT`][docker-entrypoint], but in this case it would just clutter up the fig statements.

I'll get more into this on my next article about production deployment.

### Test script (./test.sh)

Finally, we have the script that actually runs the tests.  The only unusual bit in here is that because I bake my Docker images for production use, the test script has to unroll some of the bundler settings in order to install the development and test group gems:

```bash
#!/bin/bash
set -e

# Undo the `bundle --deployment --without development test`
# settings baked into the prod-ready Docker image's .bundle/config
bundle config --delete without
bundle config --delete frozen
# Install gems in development and test groups
bundle
# Ensure database exists and has latest migrations
bundle exec rake db:create
bundle exec rake db:migrate
# Run tests
bundle exec rake

```

### Summing up

At this point, we have a working setup for doing local CI testing.  Any developer that checks out our repo and has Docker, fig, and `make` installed can immediately run `make test` and run our full suite of tests without having to manually install other needed services.

Now on to remote builds with CircleCI.

## CircleCI and circle.yml

CircleCI uses `circle.yml` to configure builds.  If you've seen [Travis CI][travis-ci] builds before, it's similar to `.travis.yml`.

Here's the circle.yml from the example repo:

```yaml
machine:
  services:
    - docker

dependencies:
  override:
    - sudo ./install-fig.sh
    - make build

database:
  override:
    - /bin/true

test:
  override:
    - make test

deployment:
  prod:
    branch: master
    commands:
      - docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
      - docker push abevoelker/example_rails_docker_ci:latest
      - docker tag abevoelker/example_rails_docker_ci:latest abevoelker/example_rails_docker_ci:$CIRCLE_SHA1
      - docker push abevoelker/example_rails_docker_ci:$CIRCLE_SHA1

```

Overall it's pretty readable; the build machine requires the docker service and build dependencies are fig (I had to put it into a separate install script due to backticks in the circle.yml not working properly).  `make build` is not really necessary to put in the `dependencies` section as the `make test` in the test section will run it, but I just think it looks cleaner to put it there and make it explicit for some reason.

One thing of note is the use of the `override` sections.  This is because CircleCI tries to be smart about your build, and perform automatic actions when it detects certain things (it labels these "inferences" in the build output).  For example, when it sees a Gemfile it tries to do `bundle install`, and when it sees database.yml it tries to run database migrations.  We don't want this because it's not smart enough to do these actions using our Docker containers.  By defining `override` sections in the circle.yml, we disable the use of these inferences.  The weird use of `/bin/true` in the database override section is because empty `override` sections seem to be ignored.

In the `deployment` section, a couple things are worth noting.  One is the use of `$DOCKER_EMAIL`, `$DOCKER_USER`, and `$DOCKER_PASS` environment variables.  Similar to Heroku, CircleCI has a project configuration section where you can enter sensitive variables to be used during the build.  So we can enter our secret Docker registry authentication details in this section, which are needed to push to the registry.

Another is the use of tags when doing the `docker push`.  The way the above circle.yml is configured, a `latest` tag is pushed as well as a tag consisting of the SHA-1 of the git commit that the image was built from (CircleCI conveniently exposes this as `$CIRCLE_SHA1`).  This way, you can perform rollbacks of deployments by using the git commit hash as a handy reference to corresponding Docker images.  Note that if you are using your own private registry, you may want to delete or limit this functionality as you could fill up your hard disk because these images will no longer be considered dangling images by the typical docker cleanup commands (e.g. `docker rmi $(docker images --filter dangling=true --quiet)`).

## Private image builds are cheap, by the way

The cool thing about this approach is that it is pretty cheap for building private images.  [Now that CircleCI is free][circle-ci-free] for private builds, the only thing you have to pay for is private git repos from GitHub (minimum $7/mo for 5 repos for the "micro" plan).  If CircleCI ever adds support for BitBucket, this would be completely free as BitBucket allows unlimited private git repos.

### Using a private registry

If you need more than one private image, you'll have to switch from Docker Hub as they only allow one free private image. Nearly identical to GitHub, you can pay for a Docker Hub "micro" account for $7/mo to get 5 private repositories (bonus: you'll be supporting Docker development).

If you can't afford / don't want to pay for a private registry, I recommend signing up for a free account with [Tutum][tutum], as they provide a free private registry (disclaimer: I'm currently wearing a free t-shirt they sent me so I may be biased).  I also think Tutum is on to a really awesome idea that could really take off: bridging the gap between cheap-but-you're-on-your-own VPS like DigitalOcean and expensive-but-turnkey PaaS like Amazon and Heroku by putting a really slick Docker management interface over a VPS account you own.  So basically, you connect your DigitalOcean account, and they provide a nice interface for managing how many DigitalOcean VMs to spin up, how to start up the Docker containers for your services (and linking them), and handling deploys.  They've also [authored a bunch of open-source Docker images][tutum-open-source-images] to help people get started running their own Dockerized services.

I'll probably write a little more about Tutum in my next blog post about production Docker deployments, if I ever finish it!

Alternatively to that, you can easily run your own [Docker registry][docker-registry] on your own server.

If you do switch to a different registry, you'll just have to add the registry information to the `deployment` section of the `circle.yml` file like so:

```yaml
deployment:
  prod:
    branch: master
    commands:
      - docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS $DOCKER_REGISTRY
      - docker push $DOCKER_REGISTRY/abevoelker/example_rails_docker_ci:latest
      - docker tag $DOCKER_REGISTRY/abevoelker/example_rails_docker_ci:latest $DOCKER_REGISTRY/abevoelker/example_rails_docker_ci:$CIRCLE_SHA1
      - docker push $DOCKER_REGISTRY/abevoelker/example_rails_docker_ci:$CIRCLE_SHA1

```

## Conclusion

Thanks for reading!  I hope you'll check back in when I finish the article on production deploys of Rails using Docker and unveil the MVP I've been working on in my spare time.

## References

* [Example Docker circle.yml inspiration][example-circle-yml]
* [Makefile inspiration][makefile-inspiration]


[rails-development-docker]:   /rails-development-using-docker-and-vagrant
[fig]:                        http://www.fig.sh/
[make]:                       http://www.gnu.org/software/make/
[circleci]:                   https://circleci.com/
[example-repo]:               https://github.com/abevoelker/example_rails_docker_ci
[docker-install]:             https://docs.docker.com/installation/
[fig-install]:                http://www.fig.sh/install.html
[makefile-rules]:             http://en.wikipedia.org/wiki/Makefile#Rules
[docker-links-env-variables]: https://docs.docker.com/userguide/dockerlinks/#environment-variables
[docker-entrypoint]:          https://docs.docker.com/reference/builder/#entrypoint
[travis-ci]:                  https://travis-ci.org/
[circle-ci-free]:             http://blog.circleci.com/continuous-integration-and-deployment-on-circleci-just-got-better-now-its-free/
[tutum]:                      https://www.tutum.co/
[tutum-images]:               https://registry.hub.docker.com/repos/tutum/
[tutum-open-source-images]:   https://github.com/tutumcloud?page=1&query=tutum-docker
[docker-registry]:            https://github.com/docker/docker-registry
[example-circle-yml]:         https://github.com/circleci/docker-hello-google/blob/master/circle.yml
[makefile-inspiration]:       https://github.com/modcloth/modcloth-docker-layers/blob/master/meta.mk
