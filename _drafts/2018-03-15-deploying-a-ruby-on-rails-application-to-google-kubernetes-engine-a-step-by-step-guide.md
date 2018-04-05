---
layout: post
title: "Deploying a Ruby on Rails application to Google Kubernetes Engine: a step-by-step guide"
date: 2018-03-15
comments: false
og_image: "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/gke drawing.png"
excerpt_separator: <!--more-->
---

[{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/gke drawing.png" alt="Drawing of Kubernetes application design" %}]({{ page.url }})

Following up on [my last post](https://blog.abevoelker.com/2018-01-18/why-im-switching-from-aws-to-gcp-for-new-personal-projects/) on why I'm switching personal projects from AWS to Google Cloud (GCP), this post will walk through deploying an example Ruby on Rails application to GCP's Kubernetes Engine (GKE). You should be able to follow this tutorial without experience with Ruby or Rails (please let me know if I fail at this).

<!--more-->

We will deploy [a simple app](https://github.com/abevoelker/gke-demo) that allows anyone to upload images with captions:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_4.png" alt="Screenshot of Captioned Image Uploader demo application" %}
</div>

Uploaded images will be stored in Cloud Storage and the captions will be stored in Cloud SQL Postgres.

We'll also cover serving [Brotli-compressed](https://en.wikipedia.org/wiki/Brotli) static assets from an nginx sidecar container with Cloud CDN caching enabled on a [cookieless domain](https://gtmetrix.com/serve-static-content-from-a-cookieless-domain.html), performing remote Docker builds using [Container Builder](https://cloud.google.com/container-builder/) and [Container Registry](https://cloud.google.com/container-registry/), using `jemalloc` to [improve memory usage/performance](https://www.levups.com/en/blog/2017/optimize_ruby_memory_usage_jemalloc_heroku_scalingo.html), IPv6 support, and popping a remote `rails console` for debugging.

<div class="alert alert-warning" markdown="1">
**Warning**: Running this demo will create resources on GCP and may incur a small cost while running. Remember to delete the project when you are finished so that you don't get charged unnecessarily:

```console
$ gcloud projects delete $PROJECT_ID
```
</div>

## Prerequisites

* [Sign up for Google Cloud](https://cloud.google.com/)
* [Install the Google Cloud SDK](https://cloud.google.com/sdk/downloads), which will install the `gcloud` and [`gsutil`](https://cloud.google.com/storage/docs/gsutil_install) CLI tools
* [Install `kubectl` CLI tool](https://cloud.google.com/kubernetes-engine/docs/quickstart#choosing_a_shell)[^kubectl-install]
* [Install `jq`](https://stedolan.github.io/jq/download/), needed for some scripting
* Have 2 DNS addresses that you can make A and AAAA records for. One will be used for hosting the web app, and the other static assets.

[^kubectl-install]:
    After installing the Google Cloud SDK, it can be installed with

    ```console
    $ gcloud components install kubectl
    ```

## Clone the demo app

First let's clone the [demo Rails app](https://github.com/abevoelker/gke-demo) from GitHub:

```console
$ git clone https://github.com/abevoelker/gke-demo.git
```

Although not required for the rest of the tutorial, if you'd like to test the app out locally you can [install docker-compose](https://docs.docker.com/compose/install/#install-compose) and run:

```console
$ docker-compose up
```

Which will bring up a development version of the application at [http://localhost:3000](http://localhost:3000).

If you're a Ruby/Rails developer, I put notes [at the end of the article](#extras-for-rails-developers) about how and why I made some choices when packaging this app that may interest you.

## Create GCP project and resources

Next we'll create the GCP resources to run our app.

If you haven't [initialized the Google Cloud SDK](https://cloud.google.com/sdk/docs/initializing) to your account by executing `gcloud auth login` and `gcloud init`, do so now. It will prompt to choose various default values, including an automatically-generated project ID to start with - go ahead and accept all defaults presented. We will create a new project in a moment for our purposes.

### Project

Let's create a GCP project for our demo app. Project IDs have to be unique across all of GCP, so unfortunately my project name cannot be the same as yours. Let's generate a unique project ID and store it in an environment variable for convenience:

```console
$ export PROJECT_ID="captioned-images-$(openssl rand -hex 3)"
$ echo $PROJECT_ID
captioned-images-c5769b
```

In practice on your own projects you probably won't have to add this random junk to the end of your project IDs. For example, plain old `captioned-images` was available when I wrote this post.

Now let's create the GCP project for our demo app:

```console
$ gcloud projects create --set-as-default $PROJECT_ID
```

`--set-as-default` switches gcloud's project context to our newly-created one, meaning all subsequent gcloud commands will operate on this project by default. If at any time you want to switch the project context, you do so by setting a global "project" config value[^project-configurations] like so:

[^project-configurations]:
    These config values can be grouped into sets confusingly called "configurations," in case you want to change multiple config values at once (say if you're switching between projects or deployment environments). We'll stick to using the default configuration here for simplicity.

```console
$ gcloud config set project some-other-project-name
```

To see the current project context, you can read the project config value like so:

```console
$ gcloud config get-value project
```

Or list all current config values with

```console
$ gcloud config list
```
Other default properties are also controlled by config values, such as default region and zone. Let's set those now:

```console
$ gcloud config set compute/zone us-central1-a
$ gcloud config set compute/region us-central1
```

### Enable billing

Before we get to the next step and create actual resources, [enable billing](https://console.developers.google.com/billing/projects) in the web console for this project. Otherwise, resource creation commands will fail - sometimes with misleading errors like "The account for \<resource\> has been disabled."

### DNS

The first thing we'll do is reserve IP addresses for our app and set up DNS. This will give DNS some time to propagate while we set up the rest of the app.

First we need to enable the Compute API:

```console
$ gcloud services enable compute.googleapis.com
```

<div class="alert alert-info" markdown="1">
**Note:** We'll be enabling a lot of little APIs as we work through this tutorial. It can be annoying running into these kinds of errors when certain APIs aren't enabled:

{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_2.png" alt="Screenshot of service not enabled gcloud CLI error" %}

But Google often makes it easy to recover by providing an exact URL to visit to enable the API in the web console.

The upside to having to enable all these miscellaneous APIs is that your project is more secure by default and you'll have less billing surprises.
</div>

Then we'll reserve the IP addresses:

```console
$ gcloud compute addresses create captioned-images-ipv4-address --global --ip-version IPV4
$ gcloud compute addresses create captioned-images-ipv6-address --global --ip-version IPV6
$ gcloud compute addresses list
NAME                           REGION  ADDRESS             STATUS
captioned-images-ipv4-address          35.201.64.7         RESERVED
captioned-images-ipv6-address          2600:1901:0:439d::  RESERVED
```

<div class="alert alert-warning" markdown="1">
**Warning**: if you've signed up for a free trial GCP account, you may get an error here:

```
Quota 'STATIC_ADDRESSES' exceeded. Limit: 1.0 globally.
```

This is due to [GCP quota limits for the free trial](https://cloud.google.com/free/docs/frequently-asked-questions#limitations). The solution is to either [upgrade to a paid account](https://cloud.google.com/free/docs/frequently-asked-questions#how-to-upgrade), or proceed with the tutorial without doing the IPv6 steps.
</div>

Now you should create the A and AAAA records for whatever two DNS names you chose/own for the website and assets site using the IP addresses you just reserved. I can't give exact instructions here since you probably have a different DNS service than me, but here's what my zone file looks like with the two DNS names I'm using and the two IP addresses I reserved above:

```
assets-captioned-images.abevoelker.com. 300 IN A 35.201.64.7
assets-captioned-images.abevoelker.com. 300 IN AAAA 2600:1901:0:439d::
captioned-images.abevoelker.com. 300 IN A 35.201.64.7
captioned-images.abevoelker.com. 300 IN AAAA 2600:1901:0:439d::
```

Finally, save your DNS addresses in a couple environment variables that we'll refer to later on:

```console
$ export DNS_WEBSITE="captioned-images.abevoelker.com"
$ export DNS_ASSETS="assets-captioned-images.abevoelker.com"
```

### Cloud Storage

Now let's create a Cloud Storage bucket to store uploaded images. Like project IDs, bucket names have to be globally unique, so once again my bucket name will be different than yours. We could re-use our project ID here as a unique bucket name, but for clarity let's create a separate unique value for our bucket name:

```console
$ export BUCKET_NAME="captioned-images-$(openssl rand -hex 6)"
$ echo $BUCKET_NAME
captioned-images-9fc76933f47f
```

Now let's actually create the bucket using gsutil[^create-bucket-storage-class]:

```console
$ gsutil mb -c regional -l us-central1 gs://$BUCKET_NAME
```

[^create-bucket-storage-class]:
    We'll create it as a [regional storage class](https://cloud.google.com/storage/docs/storage-classes), since we'll be setting cache-control headers that should allow the objects to be cacheable so that [latencies are comparable to multi-region](https://medium.com/google-cloud/google-cloud-storage-what-bucket-class-for-the-best-performance-5c847ac8f9f2)

### Cloud SQL

Now let's create the Postgres SQL database that will store the captions and uploaded image metadata. If we type `gcloud sql --help`[^gcloud-sql-help] to investigate how to create the database, it might be tempting to try using `gcloud sql databases` first:

[^gcloud-sql-help]:
    `--help` can be put at the end of pretty much any command and is very helpful for navigating and discovering gcloud usage

{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_5.png" alt="Screenshot of gcloud CLI sql help" %}

But actually that command is for managing the logical database(s), when first we actually need to create the physical resource that will run the database (an instance). We're going to use the smallest/cheapest instance type since this is a demo app:

```console
$ gcloud sql instances create --database-version=POSTGRES_9_6 --tier=db-f1-micro --gce-zone=us-central1-a captioned-images-db
```

This will take a bit of time to complete as Cloud SQL turns up the instance. Once it's done, we'll finally create the database:

```console
$ gcloud sql databases create captioned-images-db --instance=captioned-images-db --charset=UTF8 --collation=en_US.UTF8
```

One of the most annoying things about GKE is that in order for our application to connect to Cloud SQL, it can't just use a regular `hostname:port` TCP connection directly. Instead, we have to run a special sidecar container alongside our app (in the same Pod), called the [Cloud SQL Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy#what_the_proxy_provides), which connects to the database through a secure tunnel and then exposes a regular `hostname:port` TCP connection to other containers in the same Pod (including our application container).

We'll look at the proxy sidecar container more later on but for now we need to enable the SQL admin service and create a SQL user for the proxy:

```console
$ gcloud services enable sqladmin.googleapis.com
$ gcloud sql users create proxyuser cloudsqlproxy~% --instance=captioned-images-db --password=foobar
```

Finally, we'll store the SQL connection info for use later on:

```console
$ export CONNECTION_NAME="$(gcloud sql instances describe captioned-images-db --format=json | jq -r '.connectionName')"
```

### Kubernetes Engine

Now let's create a Kubernetes cluster to run our app. For our database instance we used a very small machine type, but for GKE clusters I've found it runs smoother using `n1-standard-1` (1 vCPU, 3.75GB RAM) versus using the smaller [shared-core machine types](https://cloud.google.com/compute/pricing#sharedcore) +`g1-small` (0.5 vCPU, 1.7GB RAM) or `f1-micro` (0.2 vCPU, 0.6GB RAM). I think having a lot of small, weak machines in a cluster makes it hard to allocate the workload effectively (e.g. one machine may not be enough to run more than one, or maybe not even one large job).

Anyway, in this case the demo would *probably* work fine with `g1-small` but I'm going to stick with `n1-standard-1` just to be on the safe side, so you don't see odd errors related to not enough resources when K8s allocates pods.

First we have to enable the Container API:

```console
$ gcloud services enable container.googleapis.com
```

Then we'll create an autoscaling cluster which will spin up a max of 4 VMs if we run out of CPU when running K8s pods. We'll also enable autoupgrade so that GKE handles upgrading the K8s version for us:

```console
$ gcloud container clusters create captioned-images-app --enable-autoupgrade --enable-autoscaling --min-nodes=2 --max-nodes=4 --machine-type=n1-standard-1 --scopes=default,compute-rw,storage-rw,sql
```

There are lots of options available when creating clusters; you can explore them with:

```console
$ gcloud container clusters create --help
```

### Service accounts

We will be running our application under a [service account](https://cloud.google.com/iam/docs/understanding-service-accounts), so let's create that now and give it the necessary permissions for our project:

```console
$ gcloud iam service-accounts create app-user
$ export APP_USER_EMAIL="$(gcloud iam service-accounts list --format=json | jq -r '.[] | select(.email | startswith("app-user@")) | .email')"
$ echo $APP_USER_EMAIL
app-user@captioned-images-cbc464e43d1b.iam.gserviceaccount.com
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$APP_USER_EMAIL" --role='roles/storage.admin'
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$APP_USER_EMAIL" --role='roles/errorreporting.admin'
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$APP_USER_EMAIL" --role='roles/logging.admin'
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$APP_USER_EMAIL" --role='roles/monitoring.admin'
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$APP_USER_EMAIL" --role='roles/cloudtrace.agent'
```

We will also need a service account to control access to our SQL database:

```console
$ gcloud iam service-accounts create sql-user
$ export SQL_USER_EMAIL="$(gcloud iam service-accounts list --format=json | jq -r '.[] | select(.email | startswith("sql-user@")) | .email')"
$ echo $SQL_USER_EMAIL
sql-user@captioned-images-cbc464e43d1b.iam.gserviceaccount.com
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SQL_USER_EMAIL" --role='roles/cloudsql.client'
```

## Google Container Registry

Now that our GCP resources are ready, we can prepare to actually run our app on GKE. But how do we make GKE aware of our Docker image?

Using GCP's Docker registry of course, which is aptly named "[Container Registry](https://cloud.google.com/container-registry/)." Let's first enable the service:

```console
$ gcloud services enable containerregistry.googleapis.com
$ gcloud services enable cloudbuild.googleapis.com
```

Now to get the image to Container Registry, we can do it a few ways:

1. Build the image locally, and push the image blob from our machine directly to the registry
2. Submit a .tar of our local source code to [Container Builder](https://cloud.google.com/container-builder/), a service that performs remote Docker builds
3. Set up a git repository mirror that auto-builds (using Container Builder) on every push

#1 is simple, but on my machine a locally-built image is 1.3GB (due to all the static and dynamic libs installed via apt-get), so that could take quite a while to upload to GCP if you have a slow upload speed like I do.

Let's try #2 instead. Using Container Builder requires defining a `cloudbuild.yaml` file that tells it how to build the app. I'm a nice guy and already supplied that file, so we can just submit the build now. We'll set the `$COMMIT_SHA` variable[^commit-sha] so that the build is tagged with our current git commit SHA:

```console
$ export COMMIT_SHA=$(git rev-parse --verify HEAD)
$ echo $COMMIT_SHA
4824b56f52b5620c5a25d378017b24353b0c7421
$ gcloud container builds submit --config cloudbuild.yaml --substitutions=COMMIT_SHA=$COMMIT_SHA
```

[^commit-sha]:
    `$COMMIT_SHA` is a special variable to Container Builder that it is automatically provided if you have Container Builder build your image from a GCP-hosted git repo. Since we're submitting a manual build though, we have to provide the value [as a substitution](https://cloud.google.com/container-builder/docs/configuring-builds/substitute-variable-values#using_user-defined_substitutions).

    It's important to tag each build with the `$COMMIT_SHA` because that is the best practice for image references during deployments - a mutable tag like `latest` would be confusing and might be ignored for certain update commands (the command may not know that the `latest` reference changed, and not do anything). The `latest` tag will mainly be useful as a handy caching reference between builds.

The source code tarball is only a couple megabytes so the remote build should start quickly. The output of the build will be streamed to your console. Container Builder uses pretty beefy VMs for the builds so it shouldn't take very long to complete.

Once it's finished, the image will be available with these two tags:

```console
us.gcr.io/$PROJECT_ID/gke_demo:latest
us.gcr.io/$PROJECT_ID/gke_demo:$COMMIT_SHA
```

Container Builder is [actually a pretty powerful service](https://medium.com/google-cloud/container-builder-797c0dc2c991) for its simplicity, and `cloudbuild.yaml` is capable of replacing simple build pipelines that you might traditionally reach for tools like Jenkins for.

## Kubernetes quick intro

So we've got our resources created and sitting idle, and the Docker image of our application is built and ready to deploy. In order to deploy the app on GKE, we'll first have to understand some basic K8s concepts. This will be a quick introduction; if you want a full-fledged tutorial check out the [official documentation](https://kubernetes.io/docs/tutorials/) or [Kubernetes By Example](http://kubernetesbyexample.com/).

## Kubernetes abstractions

Kubernetes adds some abstractions that are useful for deploying applications. I'll explain just the ones we'll be dealing with now.

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/gke drawing.png" alt="Drawing of Kubernetes application design" %}
</div>

### [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)

The most basic abstraction is the **[Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)**, which is a group of one or more containers. Even if you're only deploying one container, that's still encapsulated as a Pod.

A Pod is similar to Docker's [linked containers](https://docs.docker.com/network/links/), but one nice difference is that when connecting to sibling containers, you simply use `localhost` for the hostname rather than futzing with environment variables or `/etc/hosts`. This works because all containers in a Pod are guaranteed to run on the same **[node](https://kubernetes.io/docs/concepts/architecture/nodes/)** (a node is an individual K8s worker machine in the cluster, which on GKE is a VM). However one annoying difference is [there is no equivalent](http://blog.reactiveops.com/kubernetes-emptydir-not-the-same-as-dockers-volumes-from) to `--volumes-from` for sharing files between containers. 😤

You should never create bare Pods directly, because they are unmanaged (if they die, nobody notices). Instead you'll define Pod templates within other K8s abstractions that will create and manage them as part of their job.

<div class="alert alert-danger" markdown="1">
**Footgun alert:** in a Pod template, if you ever want to overwrite a Docker container's `CMD`, the Kubernetes field name to use is `args`. If you use `command` you will actually overwrite the `ENTRYPOINT`!

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Good lord I spent 1/2 an hour debugging why my Kubernetes container config wasn&#39;t working and it was because k8s &quot;command&quot; doesn&#39;t overwrite Docker&#39;s CMD but rather the ENTRYPOINT. To overwrite CMD use &quot;args&quot; -.- <a href="https://t.co/mcX4n4uHNM">pic.twitter.com/mcX4n4uHNM</a></p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/940454637127262208?ref_src=twsrc%5Etfw">December 12, 2017</a></blockquote>
</div>

<div class="alert alert-secondary" markdown="1">
**Tip:** in Pod templates where the application should handle both IPv4 and IPv6 traffic, you should bind to [`localhost`](https://en.wikipedia.org/wiki/Localhost#Name_resolution) (which on most modern systems defines a loopback for both IPv4 and IPv6). This seems counter-intuitive because we think of `localhost` as being private, but remember Kubernetes is opening up container-local ports to the outside world for us.

Many applications default to binding `0.0.0.0`, but remember that's an IPv4 address which will only handle IPv4 traffic; binding to `[::1]` (the IPv6 equivalent) would likewise only yield IPv6 traffic. Without this trick your application would have to be capable of binding to both of those interfaces (or you'd have to add a custom hostname to the hosts file that does so).
</div>

### [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

**[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** mainly tackle two concerns:

1. A way to specify a desired number of Pods to be run ("replicas"[^replica-set]), continually ensuring that number is maintained by killing or spinning up new Pods as necessary
2. Intelligently transitioning between desired Pod definitions. For example, if you have a running Deployment and then change the image of the underlying Pods, the Deployment will perform a "rolling update"[^deploy-strategy] which slowly creates new Pods with the updated definition, balanced with draining outdated Pods in equal measure until all old Pods are dead (replaced with the new definition)

[^replica-set]:
    Internally, Deployments use another K8s abstraction called a [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) but you shouldn't need to worry about that unless you have advanced requirements.

[^deploy-strategy]:
    The default `RollingUpdate` update strategy is [even interchangeable](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy); you can instead choose `Recreate` which will kill all existing Pods before bringing up any new ones.

Using Deployments, you can build all sorts of deploy strategies such as [canary releases](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments), [blue-green](http://container-solutions.com/kubernetes-deployment-strategies/), ["rainbow" deploys](http://brandon.dimcheff.com/2018/02/rainbow-deploys-with-kubernetes/) and [many others](http://container-solutions.com/kubernetes-deployment-strategies/).

We'll create one Deployment to run multiple instances of our web app and ensure they remain up.

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/)

**[Services](https://kubernetes.io/docs/concepts/services-networking/service/)** are a networking abstraction that logically groups a set of Pods under a label, making them accessible from inside (and sometimes outside) the cluster from a single endpoint, while load balancing[^service-load-balancing] requests. This is useful if you have have, say, a group of "frontend" Pods that need to communicate with a "backend" group - Services tame the complexity of Pods discovering and connecting with eachother.

[^service-load-balancing]:
    Although load balancing can be disabled, creating a ["headless" Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

There are different types of services which offer different exposure methods; [this is a good article](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0) explaining some differences.

We'll create two Services for this demo to expose our web app - one for static assets that the nginx container will respond to and one for "dynamic" requests that nginx will proxy to the the Rails container. Normally we'd only need one Service for this, since we only have one Deployment / one Pod type that handles both types of request, but because we're using Cloud CDN for *only* our static assets, we have to split them at the Service level to make Cloud CDN happy.

### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

An **[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** provides external access to Services, and can provide "load balancing, SSL termination and name-based virtual hosting." On GKE, creating an Ingress automatically creates a Google Cloud Load Balancer (GCLB) - awesome!

We'll use two Ingresses to route public traffic to our app. This is solely to support IPv6 in addition to IPv4 as GCP requires separate Ingresses for this. Normally you'd pay extra for having to run two, but GCP doesn't charge for IPv6 Ingresses.

### [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)

**[ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)** are how you provide configuration data to Pods. "Map" because they are [maps of key-value pairs](https://en.wikipedia.org/wiki/Hash_table). These values can be exposed to the Pod as either environment variables or mounted as files. The config values don't have to be simple variables either - you can store entire files in config values (useful for say copying an nginx.conf).

We'll create ConfigMaps to store some configuration info for our Pods.

### [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)

**[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** store sensitive information, like passwords and private keys.

Currently Secrets [are not all that secure](https://kubernetes.io/docs/concepts/configuration/secret/#risks) - the information is base64-encoded and replicated across an etcd cluster. But there are future plans to make Secrets more secure, and currently the way it is templated gets the information out of version control, so it's still a good practice to use them now.

We'll use Secrets to store sensitive configuration info for our Pods.

### [Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)

"A **[Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)** creates one or more pods and ensures that a specified number of them successfully terminate." These are useful for one-off tasks that you need to be sure complete successfully.

We'll use a Job to run our database migrations.

## Kubernetes commands

To interact with our Kubernetes cluster (GKE), we'll be using `kubectl`. There are a lot of available commands, but we'll only be using the following:[^kubectl-help]

[^kubectl-help]:
    View the CLI help by executing a bare `kubectl` or visit the [online manual](https://kubernetes.io/docs/reference/kubectl/overview/) to see all available commands

* [`kubectl create`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create) - create a resource
* [`kubectl apply`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) - apply a configuration to a resource(s)
* [`kubectl get`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) - shows basic info about a resource(s)
* [`kubectl describe`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) - shows detailed info about a resource(s)
* [`kubectl logs`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs) - prints container logs
* [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#exec) - execute command in a container

## Kubernetes deployment

Kubernetes resource configurations are stored as YAML files called manifests.

I've stored all the Kubernetes manifests for our project under the `deploy` directory. To be precise these files are actually templates that will need to be filled in with the environment variables that we've been setting as we've went through the tutorial.

To accomplish this, I've written a homebrew `template.sh` script that uses `envsubst` from the GNU gettext package; this should already be installed on most Linuxes but if you're on Mac you may need to [install from homebrew](https://stackoverflow.com/a/37192554/215168). If you're missing a variable the script will let you know and you can set the variable and try again.

It might seem weird to use a homebrew solution here but Kubernetes doesn't ship with a templating solution,[^k8s-templating] so I thought this would be simpler than adding another third-party program to the prerequisites to complete the demo.

[^k8s-templating]:
    There are [many, many solutions](https://blog.openshift.com/kubernetes-state-app-templating/) that have sprang up in the community to fill the gap, but many are tied into larger tools or opinionated workflows (e.g. some also want to [de-dupe sections of manifests](https://github.com/thisendout/kenv)). The Kubernetes maintainers seem to be [aware of the situation](https://github.com/kubernetes/kubernetes/issues/23896#issuecomment-313544857) but for now there is no official integration.

    A mature Kubernetes deployment will probably end up using [Helm](https://helm.sh/), which comes with templating, but for a tutorial I don't want to over-complicate things.

Let's run the template script now to turn the templates into ready-to-run Kubernetes manifests:

```console
$ deploy/template.sh
deploy/k8s/configmap-nginx-conf.yml
deploy/k8s/configmap-nginx-site.yml
deploy/k8s/deploy-web.yml
deploy/k8s/ingress-ipv4.yml
deploy/k8s/ingress-ipv6.yml
deploy/k8s/jobs/job-migrate.yml
deploy/k8s/service-assets.yml
deploy/k8s/service-web.yml
```

<div class="alert alert-info">
<strong>Note</strong>: I've left all the manifests separated into their own individual files for ease of learning, but it is a best practice to <a href="https://kubernetes.io/docs/concepts/configuration/overview/#general-configuration-tips">combine related resources into the same YAML file</a>
</div>

Feel free to look through the manifests, particularly the Deployment which will be the backbone of our application. You may notice that there are some Secrets referenced there that we haven't defined yet; let's go ahead and create those now.

First let's create the Secrets containing private keys for our service accounts:

```console
$ gcloud iam service-accounts keys create deploy/.keys/app-user.json --iam-account $APP_USER_EMAIL
$ kubectl create secret generic app-user-credentials \
    --from-file=keyfile=deploy/.keys/app-user.json
$ gcloud iam service-accounts keys create deploy/.keys/sql-user.json --iam-account $SQL_USER_EMAIL
$ kubectl create secret generic cloudsql-instance-credentials \
    --from-file=credentials.json=deploy/.keys/sql-user.json
```

We'll also need to store our SQL password as a Secret:

```console
$ kubectl create secret generic cloudsql-db-credentials \
    --from-literal=username=proxyuser --from-literal=password=foobar
```

### Run the database migration

At this point everything should finally be ready for us to bring up our application!

The first thing we'll want to do is run the database migration to initialize our database. We'll do that by creating a Job:

```console
$ kubectl apply -f deploy/k8s/jobs/job-migrate.yml
job "captioned-images-db-migrate" created
```

<div class="alert alert-info" markdown="1">
**Note** that we used `kubectl apply` instead of `kubectl create`; we could've used `kubectl create` but `kubectl apply` is smart enough to create a new resource if it doesn't exist, or to modify an existing resource if the configuration we're applying doesn't match what currently exists.
</div>

We can now watch the progress of our Job with:

```console
$ kubectl get jobs
NAME                          DESIRED   SUCCESSFUL   AGE
captioned-images-db-migrate   1         0            3s
```

and see the Pods it created with:

```console
$ kubectl get pods
NAME                                READY     STATUS              RESTARTS   AGE
captioned-images-db-migrate-qzkdt   0/2       ContainerCreating   0          15s
```

<div class="alert alert-info" markdown="1">
**Note:** your pod names will be different than mine throughout the tutorial
</div>

<div class="alert alert-secondary" markdown="1">
**Tip:** if you're watching for changes, instead of re-executing `kubectl get pods` over and over you can do `kubectl get pods -w` (or `--watch`) which will poll indefinitely and automatically print changes
</div>

What we should see is the Job transition from 1 desired / 0 successful to 1 desired / 1 successful, and the Pod transition from `ContainerCreating` status to `Running`, then finally `Completed` status with `0/2` in the ready column.

Unfortunately what we actually end up with is this:

```console
$ kubectl get jobs
NAME                          DESIRED   SUCCESSFUL   AGE
captioned-images-db-migrate   1         0            5m
$ kubectl get pods
NAME                                READY     STATUS      RESTARTS   AGE
captioned-images-db-migrate-qzkdt   1/2       Completed   0          5m
```

This is due to a combination of [Kubernetes currently poorly handling sidecar containers in Jobs](https://github.com/kubernetes/kubernetes/issues/25908), and GKE needing the proxy sidecar container for database connections in the first place as well as some convolution with [how it traps signals and emits exit codes](https://github.com/GoogleCloudPlatform/cloudsql-proxy/issues/128).

There are multiple workarounds to this issue, but they are pretty hacky and would've made the manifests overly confusing for a learner. Instead I opted to deal with a little unpleasantness now - I promise the rest of this will go smoother!

So what we'll do is verify that our migration actually ran successfully by viewing the output of the Rails container:

```console
$ kubectl logs pods/captioned-images-db-migrate-qzkdt -c captioned-images-migrate
Created database 'captioned_images'
== 20180123053414 CreateCaptionedImages: migrating ============================
-- create_table(:captioned_images)
   -> 0.0090s
== 20180123053414 CreateCaptionedImages: migrated (0.0091s) ===================
```

Then we'll delete the Job and put this unpleasantness behind us:

```console
$ kubectl delete jobs/captioned-images-db-migrate
job "captioned-images-db-migrate" deleted
```

### Bring up the application

Now that our database is migrated, we can finally bring up the application. This will be really easy as `kubectl apply` accepts a directory so we can simply feed it the whole directory that contains the rest of our manifests:

```console
$ kubectl apply -f deploy/k8s
configmap "nginx-conf" created
configmap "nginx-confd" created
deployment "captioned-images-web" created
ingress "captioned-images-ipv4-ingress" created
ingress "captioned-images-ipv6-ingress" created
service "captioned-images-assets" created
service "captioned-images-web" created
```

We don't have to worry about applying manifests in order - Kubernetes will figure things out.

Now we can grab a cup of coffee, and in a couple minutes the site should be online at the DNS address you selected. While the Ingress is still spinning up, you'll see a blank page with "default backend - 404"[^ingress-spin-up] until the backend app becomes available:

[^ingress-spin-up]:
    You may also see a 502 or 500 error briefly while the Ingress is coming online and checking the `readinessProbe`.

    Our container is configured to do a `SELECT 1` when the load balancer hits `/pulse`, which ensures that our Rails server can reach our SQL database (i.e. it's ready to serve traffic). If you want to learn more about Kubernetes' probes (`readinessProbe` and `livenessProbe`), [read the documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/).

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_7.png" alt="Screenshot of Ingress 404 error" %}
</div>

If you want to keep an eye on things as they progress you can use `kubectl get`:

```console
$ kubectl get cm,deploy,ing,svc,po
NAME             DATA      AGE
cm/nginx-conf    1         1h
cm/nginx-confd   1         1h

NAME                          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/captioned-images-web   2         2         2            2           1h

NAME                                HOSTS                                                                    ADDRESS            PORTS     AGE
ing/captioned-images-ipv4-ingress   captioned-images.abevoelker.com,assets-captioned-images.abevoelker.com   130.211.47.102     80        1h
ing/captioned-images-ipv6-ingress   captioned-images.abevoelker.com,assets-captioned-images.abevoelker.com   2600:1901:0:f...   80        1h

NAME                          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
svc/captioned-images-assets   NodePort    10.51.243.119   <none>        80:31477/TCP   1h
svc/captioned-images-web      NodePort    10.51.252.114   <none>        80:31468/TCP   1h
svc/kubernetes                ClusterIP   10.51.240.1     <none>        443/TCP        1d

NAME                                      READY     STATUS    RESTARTS   AGE
po/captioned-images-web-54f7df6f9-fpfdg   3/3       Running   0          1h
po/captioned-images-web-54f7df6f9-hnxcj   3/3       Running   0          1h
```

<div class="alert alert-info" markdown="1">
**Note:** in the above command, `cm` is short for `configmap`, `ing` is short for `ingress`, etc. - you can see all shortnames with `kubectl get --help`
</div>

Or drill down into more details with `kubectl describe`:

```console
$ kubectl describe ing
# long output redacted
```

But it shouldn't take long for the complete site to become available:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_8.png" alt="Screenshot of working demo app" %}
</div>

Go ahead and try uploading a picture with a caption now - everything should be working as expected!

If you only have IPv4 like I do you can test IPv6 connectivity using a site like [ipv6-test.com](http://ipv6-test.com/validate.php).

### Enable Cloud CDN for assets

In order to accelerate static asset fetching, we should enable Cloud CDN. But we **only** want to enable it for our static assets, not our dynamic content - we don't want our root page at `/` caching stale content and never showing new pictures that people upload. And some day we might add user accounts to our app, and we don't want someone's private `/settings` page being cached and displayed to everyone else who visits that path.

We're not going to use the web console to actually enable Cloud CDN, but just to get a feel for how Cloud CDN works, if we *were* to visit the [Cloud CDN web console page](https://console.cloud.google.com/net-services/cdn/list) we'd be prompted to add an origin:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_9.png" alt="Screenshot of Cloud CDN" %}
</div>

If we then clicked that button and then selected one of our Ingresses, we'd see this screen with some opaque choices for selecting "backend services":

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_10.png" alt="Screenshot of adding an origin to Cloud CDN" %}
</div>

These [backend services](https://cloud.google.com/compute/docs/load-balancing/http/backend-service) are a component of GCP's load balancer. When using GKE, it seems that creating an Ingress creates a backend service for each Service linked to the Ingress.

GKE adds a "backends" annotation to the Ingress, so we can list them in human-readable form from the CLI with `kubectl describe`:

```console
$ kubectl describe ing/captioned-images-ipv4-ingress
# look for the Annotations section in the output
```

or machine-readable form with `kubectl get -o=json`:

```console
$ kubectl get ing/captioned-images-ipv4-ingress -o=json | jq -r '.metadata .annotations ."ingress.kubernetes.io/backends"'
{"k8s-be-31468--4f88d9d22add978a":"HEALTHY","k8s-be-31477--4f88d9d22add978a":"HEALTHY","k8s-be-31534--4f88d9d22add978a":"HEALTHY"}
```

<div class="alert alert-info" markdown="1">
**Note:** your backend service IDs will be different than mine
</div>

We can get more details on what each backend service is using `gcloud`:

```console
$ gcloud compute backend-services describe --global "k8s-be-31477--4f88d9d22add978a"
# look for the "description" key in the output
```

If we run that command for each of the three listed backend services, we'd see one is for our static assets service, one is for our regular website service, and the last seems to be a default HTTP backend for Kubernetes (don't ask me).

The static assets service is the one we want to enable Cloud CDN for, so when we find its ID we could use it to enable the correct backend service in the Cloud CDN web console, or programmatically with:

```console
$ gcloud compute backend-services update --global "k8s-be-31477--4f88d9d22add978a" --enable-cdn
```

But we don't want to go through this whole nasty manual process every time we want to use Cloud CDN with a GKE app. Luckily I wrote a script (in the `gke-demo-deploy` repo) that automates this whole process - just give it an Ingress name and the corresponding Service name and it will enable Cloud CDN for the corresponding backend service:

```console
$ deploy/enable-cloud-cdn.sh captioned-images-ipv6-ingress captioned-images-assets
enabling Cloud CDN for backend k8s-be-31477--4f88d9d22add978a
Updated [https://www.googleapis.com/compute/v1/projects/captioned-images-cbc464e43d1b/global/backendServices/k8s-be-31477--4f88d9d22add978a].
$ deploy/enable-cloud-cdn.sh captioned-images-ipv4-ingress captioned-images-assets
enabling Cloud CDN for backend k8s-be-31477--4f88d9d22add978a
No change requested; skipping update for [k8s-be-31477--4f88d9d22add978a].
```

<small>(The backend service always seems to be the same for both Ingresses so the second command isn't really necessary, but it doesn't hurt anything so I always double check anyway - the script could maybe be improved here)</small>

If we were to visit the Cloud CDN web console page we'd see the assets backend service has been CDN-ified across both Ingresses:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_11.png" alt="Screenshot of Cloud CDN showing assets backends added" %}
</div>

We can now verify that Cloud CDN is working by making an HTTP request for a static asset and verifying that [`Age:` appears in the response headers](https://cloud.google.com/cdn/docs/support#top_of_page):

```console
$ curl -I http://assets-captioned-images.abevoelker.com/assets/application-ee08f0058ad69a7cad88c4bfabd2595f037cc764cddf32ada35c6b5efabb26a8.css
HTTP/1.1 200 OK
Server: nginx/1.13.8
Date: Tue, 27 Mar 2018 02:22:03 GMT
Content-Type: text/css
Content-Length: 988
Last-Modified: Sun, 25 Mar 2018 19:14:27 GMT
Vary: Accept-Encoding
Access-Control-Allow-Origin: http://captioned-images.abevoelker.com
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type
Accept-Ranges: bytes
Via: 1.1 google
Cache-Control: public,max-age=31536000
Age: 454
```

<small>(You can find a static asset URL by viewing the HTML source of your deployed app - there should be a hashed application.css and application.js URL to choose from)</small>

And now we can use a [tool like this one](https://latency.apex.sh) using our application.css asset URL to verify it loads quickly (mostly) across the globe:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_12.png" alt="Chart of asset load latencies from various global locations" %}
</div>

In my opinion, ideally GKE would support a special annotation on the Ingress manifest which would enable Cloud CDN for the backend service via Kubernetes. If you support that idea [please star my Google issue](https://issuetracker.google.com/issues/71536907).

<div class="alert alert-warning" markdown="1">
**Warning:** if you enable Cloud CDN on your own app, it is [critical to properly set the `Vary` header](https://cloud.google.com/cdn/docs/support#compression-not-working), otherwise you'll have clients get unexpectedly-compressed responses and vice-versa. Check the nginx configuration of this demo app if you want to see how I do it.
</div>

### Redeploying the application

Now that we've successfully deployed our application, what do we do when we need to make a change?

Go ahead and change the "v1.0" in the `<h1>` to "v1.1". Then commit the change and submit a new build:

```console
$ export COMMIT_SHA=$(git rev-parse --verify HEAD)
$ gcloud container builds submit --config cloudbuild.yaml --substitutions=COMMIT_SHA=$COMMIT_SHA
```

Then when the remote Docker build is complete, we'll run our template script to update the Kubernetes manifests then run `kubectl apply` to update the Deployment:

```console
$ deploy/template.sh
$ kubectl apply -f deploy/k8s/deploy-web.yml
```

Alternatively, in scenarios like this where only a Docker image has changed, we can use `kubectl set image`:

```console
$ kubectl set image deployment/captioned-images-web captioned-images-web=us.gcr.io/$PROJECT_ID/gke_demo:$COMMIT_SHA
```

After a short wait while the Deployment updates, voilà:

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/image_13.png" alt="Screenshot of version 1.1 of the application" %}
</div>

<div class="alert alert-info" markdown="1">
**Note:** `kubectl set image` obviously won't update your local manifest file with whatever the current version of the Deployment looks like. To dump the current version of a resource as YAML, we can do:

```console
$ kubectl get deployment/captioned-images-web -o=yaml
```

However be aware a lot of extra fields will come back that you probably won't have in your own hand-created manifest file, as this is a "complete" snapshot of the resource.
</div>

<div class="alert alert-warning" markdown="1">
**Warning:** if your application change is only an update to a ConfigMap, be aware that redeploying a Deployment that depends on it (with no other changes to the Deployment) will result in no change to the Deployment. In short the Deployment won't detect that the ConfigMap changed.

I usually add a junk environment variable to one of the Deployment's containers in this scenario, which will force a fresh redeploy that picks up the ConfigMap change.
</div>

## Enable TLS/SSL using Let's Encrypt

<div style="display: flex; align-items: center; justify-content: center;">
{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/lets-encrypt-logo.png" alt="Let's Encrypt logo" width="320px" height="320px" %}
</div>

This is one area that unfortunately GCP/GKE is at a major deficit compared to AWS, the latter of which has the [AWS Certificate Manager (ACM)](https://aws.amazon.com/certificate-manager/) which can easily provision SSL/TLS certificates, attach them directly to load balancers (or CloudFront - their CDN), and automatically renew them. I've said many times on Twitter that this is the primary feature that I really miss migrating from AWS:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I think the only thing I would really miss moving to Google Cloud right now is AWS&#39;s certificate manager (ACM) and its ALB/ELB integration</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/839954994803720194?ref_src=twsrc%5Etfw">March 9, 2017</a></blockquote>

And I'm not the only one:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Really impressed by Google Cloud Platform so far. It&#39;s like AWS minus the obfuscated Amazonspeak, and with a better console.<br><br>The only service I miss is ACM — zero-hassle HTTPS is *such* a killer feature. A Kubernetes/Let&#39;s Encrypt Rube Goldberg machine just isn&#39;t the same.</p>&mdash; Brandur (@brandur) <a href="https://twitter.com/brandur/status/973357848863244289?ref_src=twsrc%5Etfw">March 13, 2018</a></blockquote>

Instead we will be using [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) to provision free certificates using [cert-manager](https://github.com/jetstack/cert-manager), which is a Kubernetes add-on that we'll install into our cluster that automatically performs the magic handshakes with Let's Encrypt to verify we own the domains we need certificates for and handles certificate renewals.

Let's Encrypt allows validating domains via its [ACME protocol](https://letsencrypt.org/how-it-works/) by either serving a special URI via HTTP or by serving a special TXT record via DNS. While cert-manager supports both methods, and HTTP seems to be the most popular, I had [nothing but problems with it](https://github.com/jetstack/cert-manager/issues/281) so I will be demonstrating the DNS TXT record method in this post. If you want to try the HTTP method there is [an excellent tutorial here](https://github.com/ahmetb/gke-letsencrypt), however apparently [it is broken as of this writing](https://github.com/jetstack/cert-manager/issues/347#issuecomment-368758773).

I will demonstrate using GCP as the DNS provider, which along with AWS Route 53, Cloudflare, and Azure are currently the only DNS providers cert-manager supports (see [the project's example `acme-issuer.yaml`](https://github.com/jetstack/cert-manager/blob/acfc2f78d1eb0582447d3d25d8efc452e20d5547/docs/examples/acme-issuer.yaml) for how to modify the Issuer manifest to accommodate other DNS providers). Unfortunately if you don't use one of the aforementioned DNS providers, you won't be able to follow along - maybe try the aforementioned [HTTP method tutorial](https://github.com/ahmetb/gke-letsencrypt) instead.

### DNS service account

First, we need to enable the DNS API:

```console
$ gcloud services enable dns.googleapis.com
```

Now, we are going to need a service account with privileges to modify our DNS:

```console
$ gcloud iam service-accounts create dns-user
$ export DNS_USER_EMAIL="$(gcloud iam service-accounts list --format=json | jq -r '.[] | select(.email | startswith("dns-user@")) | .email')"
$ echo $DNS_USER_EMAIL
dns-user@captioned-images-cbc464e43d1b.iam.gserviceaccount.com
$ gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$DNS_USER_EMAIL" --role='roles/dns.admin'
```

We will need to save the service account credentials as a secret to be consumed in our Kubernetes manifests:

```console
$ gcloud iam service-accounts keys create deploy/.keys/dns-user.json --iam-account $DNS_USER_EMAIL
$ kubectl create secret generic dns-svc-acct-secret \
    --from-file=credentials.json=deploy/.keys/dns-user.json
```

### Install Helm

Next we need to install Helm, the Kubernetes package manager:

```console
$ kubectl create serviceaccount -n kube-system tiller
$ kubectl create clusterrolebinding tiller-binding \
    --clusterrole=cluster-admin \
    --serviceaccount kube-system:tiller
$ helm init --service-account tiller
$ helm repo update
```

### Install cert-manager

Now it's time to install cert-manager using Helm:

```console
$ helm install --name cert-manager \
    --namespace kube-system stable/cert-manager
```

### Provision Issuer and Certificate manifests

cert-manager takes a really neat approach and introduces two new Kubernetes resource types, Issuer and Certificate.

Issuer defines a certificate issuer - i.e. where you can get a certificate from. We'll define two: one for Let's Encrypt's staging endpoint, and one for the production endpoint. We'll go straight to using the production endpoint, but staging should generally be used first since the rate limiting is more permissive, so if you run into errors you can debug them quicker before you cut over to production.

Certificate defines the structure of the X.509 certificate we want issued and specifies which method to use to validate it (HTTP or DNS).

I've added manifests for these two resources under the `deploy/k8s/ssl` folder, which we haven't interacted with yet. Go ahead and read the .yml files to see how they're structured, then let's use our template script to fill in the needed values (also supplying a new `EMAIL` value, which Let's Encrypt may use to notify us if our certificate is nearing expiration):

```console
$ EMAIL='abe@abevoelker.com' deploy/template.sh
deploy/k8s/configmap-nginx-conf.yml
deploy/k8s/configmap-nginx-site.yml
deploy/k8s/deploy-web.yml
deploy/k8s/ingress-ipv4.yml
deploy/k8s/ingress-ipv6.yml
deploy/k8s/jobs/job-migrate.yml
deploy/k8s/service-assets.yml
deploy/k8s/service-web.yml
deploy/k8s/ssl/certificate.yml
deploy/k8s/ssl/issuer.yml
$ kubectl create -f deploy/k8s/ssl/issuer.yml
clusterissuer "letsencrypt-staging" created
clusterissuer "letsencrypt-prod" created
$ kubectl create -f deploy/k8s/ssl/certificate.yml
certificate "captioned-images-tls" created
```

Once we provision the Certificate, cert-manager should begin contacting the Let's Encrypt server and doing the ACME validation dance. We can check on the progress with:

```console
$ kubectl describe certificate
```

The "Events" section is where to look to keep an eye on the progress. Once finished successfully (it may take several minutes), it should look like something like this:

```
Events:
  Type     Reason                 Age              From                     Message
  ----     ------                 ----             ----                     -------
  Warning  ErrorCheckCertificate  4m               cert-manager-controller  Error checking existing TLS certificate: secret "captioned-images-tls" not found
  Normal   PrepareCertificate     4m               cert-manager-controller  Preparing certificate with issuer
  Normal   PresentChallenge       4m               cert-manager-controller  Presenting dns-01 challenge for domain assets-captioned-images.abevoelker.com
  Normal   PresentChallenge       4m               cert-manager-controller  Presenting dns-01 challenge for domain captioned-images.abevoelker.com
  Normal   SelfCheck              4m               cert-manager-controller  Performing self-check for domain captioned-images.abevoelker.com
  Normal   SelfCheck              4m               cert-manager-controller  Performing self-check for domain assets-captioned-images.abevoelker.com
  Normal   ObtainAuthorization    2m               cert-manager-controller  Obtained authorization for domain assets-captioned-images.abevoelker.com
  Normal   ObtainAuthorization    2m               cert-manager-controller  Obtained authorization for domain captioned-images.abevoelker.com
  Normal   IssueCertificate       2m               cert-manager-controller  Issuing certificate...
  Normal   CeritifcateIssued      2m               cert-manager-controller  Certificated issued successfully
  Normal   RenewalScheduled       2m (x2 over 2m)  cert-manager-controller  Certificate scheduled for renewal in 1438 hours
```

At this point we'll also have a new secret of type `kubernetes.io/tls` which contains the actual SSL/TLS certificate:

```console
$ kubectl get secrets --field-selector=type="kubernetes.io/tls"
NAME                   TYPE                DATA      AGE
captioned-images-tls   kubernetes.io/tls   2         20m
```

### Attach certificate to Ingresses

Now that we have our certificate, it's time to attach it to our Ingresses so that SSL starts working!

I have put the changes to our Ingress and other manifests on a separate git branch named "ssl"; let's check that out now:

```console
$ git fetch
$ git checkout ssl
```

If we [compare the changes between the master and ssl branch](https://github.com/abevoelker/gke-demo/compare/master...ssl), this is what we added to the Ingresses:

```diff
diff --git a/deploy/templates/k8s/ingress-ipv4.yml b/deploy/templates/k8s/ingress-ipv4.yml
index 1283910..b6ada67 100644
--- a/deploy/templates/k8s/ingress-ipv4.yml
+++ b/deploy/templates/k8s/ingress-ipv4.yml
@@ -5,6 +5,11 @@ metadata:
   annotations:
     kubernetes.io/ingress.global-static-ip-name: captioned-images-ipv4-address
 spec:
+  tls:
+  - secretName: captioned-images-tls
+    hosts:
+    - ${DNS_WEBSITE}
+    - ${DNS_ASSETS}
   rules:
   - host: ${DNS_WEBSITE}
     http:
diff --git a/deploy/templates/k8s/ingress-ipv6.yml b/deploy/templates/k8s/ingress-ipv6.yml
index 573bf75..c573b90 100644
--- a/deploy/templates/k8s/ingress-ipv6.yml
+++ b/deploy/templates/k8s/ingress-ipv6.yml
@@ -5,6 +5,11 @@ metadata:
   annotations:
     kubernetes.io/ingress.global-static-ip-name: captioned-images-ipv6-address
 spec:
+  tls:
+  - secretName: captioned-images-tls
+    hosts:
+    - ${DNS_WEBSITE}
+    - ${DNS_ASSETS}
   rules:
   - host: ${DNS_WEBSITE}
     http:
```

Let's regenerate our manifests using the updated templates and apply the updated Ingress manifests:

```console
$ EMAIL=abe@abevoelker.com ./template.sh
$ kubectl apply -f deploy/k8s/ingress-ipv4.yml
$ kubectl apply -f deploy/k8s/ingress-ipv6.yml
```

After a few minutes, you should be able to access your site using https://! It will look a little funky at first because Rails is still serving assets using http:// URLs, so Chrome and other modern browsers will refuse to load the assets (so the stylesheet will not load):

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/ssl-content-warning.png" alt="Screenshot of app running over HTTPS with insecure content warning blocking assets" %}
</div>

Let's fix that now by applying the rest of the changes I made to the SSL branch, which will configure Rails and nginx to force everything to HTTPS:

```console
$ kubectl apply -f deploy/k8s
```

After the Deployment finishes updating, everything should be working over HTTPS without any warnings!

<div style="display: flex; align-items: center; justify-content: center;">
  {% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/ssl-fully-working.png" alt="Screenshot of app running over HTTPS successfully" %}
</div>

### Let's ask Google to do better

Unfortunately, while tools like cert-manager and kube-lego are really neat, they still leave the responsibility for renewing certificates in our hands and increase the maintenance burden of our GKE clusters (e.g. what happens when we upgrade our Kubernetes version? Do things keep working?[^kube-lego-deprecation]). We have to keep an eye on a new spinning cog in our cluster and still set up health checks on certificate expirations lest we be surprised:

[^kube-lego-deprecation]:
    kube-lego for example has been deprecated and is no longer tested on the latest version of Kubernetes.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Great, kube-lego decided to break at some point and now I have an expired SSL cert. GCP&#39;s reliance on Kubernetes cluster-integrated tools like kube-lego, cert-manager, etc. is a big issue compared to AWS&#39;s ACM simplicity</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/976871230883160064?ref_src=twsrc%5Etfw">March 22, 2018</a></blockquote>

If you agree that GCP should have a similar product to AWS's ACM, please star [the issue I opened requesting this feature](https://issuetracker.google.com/issues/70801227).

### Opening a remote Rails console

The simplest way to open a Rails console is attaching to a running Rails server that's part of a Deployment using `kubectl exec`:

```console
$ kubectl get pods
NAME                                    READY     STATUS    RESTARTS   AGE
captioned-images-web-588759688d-8dlxp   3/3       Running   0          1d
captioned-images-web-588759688d-x87qr   3/3       Running   0          1d
$ kubectl exec -it captioned-images-web-588759688d-8dlxp -c captioned-images-web -- /var/www/docker/docker-entrypoint.sh bash
web@captioned-images-web-588759688d-8dlxp:/var/www$ bundle exec rails c
Loading production environment (Rails 5.1.4)
irb(main):001:0> CaptionedImage.count
D, [2018-03-29T02:07:43.331468 #54] DEBUG -- :    (14.2ms)  SELECT COUNT(*) FROM "captioned_images"
=> 1
irb(main):002:0> CaptionedImage.first
D, [2018-03-29T02:11:33.687385 #54] DEBUG -- :   CaptionedImage Load (6.6ms)  SELECT  "captioned_images".* FROM "captioned_images" ORDER BY "captioned_images"."id" ASC LIMIT $1  [["LIMIT", 1]]
=> #<CaptionedImage id: 1, caption: "test", image_data: "{\"original\":{\"id\":\"82e9768a035d39050eaf01689537fdf...", created_at: "2018-03-26 19:05:58", updated_at: "2018-03-26 19:05:59">
irb(main):003:0>
```

A better way to do it would be to create a one-off Pod, copying the Pod template/spec from the Deployment, and running the Rails console on that Pod. Because affecting the resources of a running web server Pod that's handling traffic is not the best idea.

## Conclusion

Docker was revolutionary, but it mainly gave us low-level primitives without a way to assemble them for production-ready application deployments. I hope through this tutorial I've shown that Kubernetes meets and exceeds that need by providing the abstractions that let us express application deployments in logical terms, and that GKE is an excellent managed Kubernetes solution.

I'll close with a great thought by Kelsey Hightower, in that Kubernetes isn't the final word in a story that doesn't end:

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Docker wrote the developer story. Kubernetes expanded the narrative and added some new chapters, but the story has no ending.</p>&mdash; Kelsey Hightower (@kelseyhightower) <a href="https://twitter.com/kelseyhightower/status/969611963876622336?ref_src=twsrc%5Etfw">March 2, 2018</a></blockquote>

## Topics for further exploration

This blog post turned into a novel, and yet there are still many topics that I didn't cover well. Here are some you should check out on your own.

### Web console, Stackdriver

We did a lot of work in the CLI in this post, but GCP's web console is pretty nice, and there are a lot of features available that are worth exploring there.

In particular I suggest checking out the Stackdriver features [Logs](https://console.cloud.google.com/logs/viewer), [Error Reporting](https://console.cloud.google.com/errors), and [Trace](https://console.cloud.google.com/traces/overview). Error Reporting will require the service to be enabled:

```console
$ gcloud services enable clouderrorreporting.googleapis.com
```

### Declarative cloud provisioning
{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/terraform.png" alt="Terraform logo" %}

We did a whole lot of manual `gcloud` and `gsutil` CLI commands to provision cloud resources, which is really unwieldy and error-prone for non-trivial projects.

An alternative is using a tool like [Terraform](https://www.terraform.io/) in which you declaratively specify the resources you need and Terraform creates/modifies/deletes to achieve that state. Terraform plans can have [output variables](https://www.terraform.io/intro/getting-started/outputs.html) which can be fed into other tools like Kubernetes manifest templating.

### Continuous Integration (CI) and Continuous Delivery (CD)

Manually submitting Docker image builds and then manually deploying them like we did is obviously not sustainable for a real project.

There are unlimited possibilities for automating the builds and deploys; a simple first step might be setting up a [Container Builder build trigger](https://cloud.google.com/container-builder/docs/running-builds/automate-builds) to automatically build a Docker image when there's a new push to the git repo.

Tools that are specific to Kubernetes CI/CD that I think are worth mentioning include [Keel](https://keel.sh/) and [Jenkins X](http://jenkins-x.io/) (I haven't tried either one but have heard good things).

### Helm
{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/helm.png" style="width: 200px;" alt="Helm logo" %}

[Helm is Kubernetes's official package manager](https://helm.sh/). It lets you install bundled up apps (called Charts) into your own Kubernetes cluster, but can also be useful for organizing your own project's resources. It also comes with templating so if nothing else it can replace the `envsubst` solution we did earlier.

### Kubernetes manifest templating

Speaking of templating, I mentioned in a footnote[^k8s-templating] earlier that there are many solutions worth investigating. You should try to find one that fits your workflow the best.

### Firewalls

We didn't touch on [configuring firewalls](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod#firewalling), but that should be investigated for a production GKE cluster.

Kubernetes itself also has a [Network Policy feature](https://github.com/ahmetb/kubernetes-network-policy-recipes) that may be worth checking out.

### AppEngine

GKE and Kubernetes give you a lot of power for deploying and managing your application, but also a lot of complexity. If you have a really simply application, it's worth considering simpler PaaS-style alternatives.

In this vein GCP has [AppEngine](https://cloud.google.com/appengine/), which supports several programming languages upfront as well as custom workloads using containers ([AppEngine Flex](https://cloud.google.com/appengine/docs/flexible/)). [Here's a nice article](https://medium.com/google-cloud/app-engine-flex-container-engine-946fbc2fe00a) that can help one decide whether to use App Engine Flex or GKE.

## Thank you

HUGE thanks to my reviewers, Daniel Brice ([@fried_brice](https://twitter.com/fried_brice)) and Sunny R. Juneja ([@sunnyrjuneja](https://twitter.com/sunnyrjuneja)) for reviewing very rough drafts of this blog post and providing feedback. 😍 They stepped on a lot of rakes so that you didn't have to - please give them a follow! 😀

Any mistakes in this post remain of course solely my own.

## References

Here are some miscellaneous links I found useful while learning Kubernetes/GKE that I couldn't find a relevant place to link to earlier in this post.

[Code Cooking: Kubernetes](https://medium.com/google-cloud/code-cooking-kubernetes-e715728a578c)

[Managing Rails tasks such as 'db:migrate' and 'db:seed' on Kubernetes while performing rolling deployments](https://blog.bigbinary.com/2017/06/16/managing-rails-tasks-such-as-db-migrate-and-db-seed-on-kuberenetes-while-performing-rolling-deployments.html)

[Global ingress in practice on Google Container Engine — Part 1: Discussion](https://medium.com/google-cloud/global-ingress-in-practice-on-google-container-engine-part-1-discussion-ccc1e5b27bd0)

[Kubernetes Engine Samples](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples)

[Understanding kubernetes networking: pods](https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727)

## Extras for Rails developers

In the interest of keeping the tutorial as content-agnostic as possible I moved Rails-specific notes to the end. If you're a Rails developer and had some questions or concerns hopefully this section addresses them.

### Why an nginx reverse proxy?

Some folks will recommend configuring Rails to serve static assets, and [simply put a CDN in front](http://guides.rubyonrails.org/asset_pipeline.html#cdns) to cache assets so that only the first asset request (which actually hits Rails) is slow. However, I like that nginx reduces the need to have a bunch of Rack middleware (e.g. for [enforcing SSL access](https://github.com/tobmatth/rack-ssl-enforcer), [gzip-compressing requests](https://robots.thoughtbot.com/content-compression-with-rack-deflater), [aborting slow requests](https://github.com/heroku/rack-timeout)), and supports features Rails/Rack doesn't have quite yet (like [on-the-fly brotli compression](https://github.com/google/ngx_brotli)), as well as letting you opt-out of using a CDN while still having decent asset load performance.

The cost of course is running another container in each application server Pod. I think it's worth that marginal extra cost in resources and deployment complexity, but I appreciate others won't.

### Dockerfile

A couple things to note about the Dockerfile:

* Ruby is compiled using jemalloc to improve memory usage and performance
* Brotli compression is done by a custom Python script that runs after the normal `rake assets:precompile` step rather than being integrated into the asset pipeline. There is [a gem](https://github.com/hansottowirtz/sprockets-exporters_pack/wiki/How-to-enable-Brotli-with-Rails-and%C2%A0Nginx) that can add Brotli compression directly to Sprockets, but it depends on a newer version of Sprockets [that I find buggy](https://github.com/rails/sprockets/issues/474), so for now I still use my own script

I also included a Makefile like I do on most projects, so that I can just type `make build` to build the image or `make push` to push it without having to remember what I named the Docker image or what Docker registry I'm using. I usually also include a `make test` that is sort of a poor man's CI that builds the image and runs `rake test` using docker-compose, but this app doesn't have tests because it's not the focus of the blog post.

### Useful gems

A few lesser-known gems I used in the demo app that I think deserve some props:

* [Shrine](https://github.com/shrinerb/shrine) is extremely pleasant for handling image uploads compared to previous experiences I've had with Carrierwave, Paperclip, and Refile.
* [rails-pulse](https://rubygems.org/gems/rails-pulse) is a simple gem that handles the health checking by setting up a route that does a `SELECT 1` to ensure the database is up.
* [ENVied](https://github.com/eval/envied) is really useful to ensure the app fails fast (at bootup) if I'm missing a required environment variable.

## Footnotes
