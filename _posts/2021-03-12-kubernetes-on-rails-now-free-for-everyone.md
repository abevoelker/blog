---
title: "Kubernetes on Rails: now free for everyone!"
date: 2021-03-12 00:00
comments: false
additional_css:
  - "kubernetes-on-rails-now-free-for-everyone.scss"
toc: true
toc_label: "Sections"
toc_sticky: true
---

<h2 id="intro" style="display: none;">Introduction</h2>

Back in mid-2018, I slogged through learning Kubernetes in order to deploy a Rails web app using it, and I spent quite a bit of time turning that knowledge into [a series of detailed blog posts](/2018-04-05/deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide-part-1/).

A little while after completing those blog posts, I was going to make an editorial pass to tighten things up when I realized the content would be much better delivered via screencast rather than written out into long instructions and screenshots. In a fit of mania, I decided to do that and charge a small amount of money for access to the videos.

Now, over two years and nearly 150 customers later, purchases have died down a bit - I still get the odd purchase every couple weeks or so, including one this week - but at this point I feel bad because although I believe that the meat of the content is still valuable, some of the ecosystem has changed slightly so the material isn't strictly up-to-date in the handheld, step-by-step fashion I intended the videos to be.

Therefore I've decided to make the screencasts freely available for all, and if you feel like you got something from them worthy of remuneration you can just [PayPal me here](https://paypal.me/abeeeeeee?locale.x=en_US):

[{% asset "kubernetes-on-rails-now-free-for-everyone/paypal-logo.svg" class="align-center" %}](https://paypal.me/abeeeeeee?locale.x=en_US)

## Customer thank you

I'm so humbled that almost 150 people bought the screencasts. I wish I had asked for everybody's first name when accepting payment so that I could display them all here (with their permission).

One thing that surprised me that I'm able to share is all the different countries that purchasers hailed from!

<div class="grid-container grid-container--fit" style="margin-bottom: 1em;">
  <div class="grid-element">
    🇦🇷 (Argentina)
  </div>
  <div class="grid-element">
    🇦🇹 (Austria)
  </div>
  <div class="grid-element">
    🇦🇺 (Australia)
  </div>
  <div class="grid-element">
    🇧🇦 (Bosnia and Herzegovina)
  </div>
  <div class="grid-element">
    🇧🇪 (Belgium)
  </div>
  <div class="grid-element">
    🇧🇷 (Brazil)
  </div>
  <div class="grid-element">
    🇧🇾 (Belarus)
  </div>
  <div class="grid-element">
    🇨🇦 (Canada)
  </div>
  <div class="grid-element">
    🇨🇷 (Costa Rica)
  </div>
  <div class="grid-element">
    🇩🇪 (Germany)
  </div>
  <div class="grid-element">
    🇩🇰 (Denmark)
  </div>
  <div class="grid-element">
    🇪🇸 (Spain)
  </div>
  <div class="grid-element">
    🇫🇷 (France)
  </div>
  <div class="grid-element">
    🇬🇧 (United Kingdom)
  </div>
  <div class="grid-element">
    🇬🇷 (Greece)
  </div>
  <div class="grid-element">
    🇬🇹 (Guatemala)
  </div>
  <div class="grid-element">
    🇭🇰 (Hong Kong)
  </div>
  <div class="grid-element">
    🇮🇩 (Indonesia)
  </div>
  <div class="grid-element">
    🇮🇪 (Ireland)
  </div>
  <div class="grid-element">
    🇮🇳 (India)
  </div>
  <div class="grid-element">
    🇯🇵 (Japan)
  </div>
  <div class="grid-element">
    🇰🇷 (South Korea)
  </div>
  <div class="grid-element">
    🇱🇺 (Luxembourg)
  </div>
  <div class="grid-element">
    🇲🇰 (Macedonia)
  </div>
  <div class="grid-element">
    🇲🇽 (Mexico)
  </div>
  <div class="grid-element">
    🇲🇾 (Malaysia)
  </div>
  <div class="grid-element">
    🇳🇱 (Netherlands)
  </div>
  <div class="grid-element">
    🇳🇴 (Norway)
  </div>
  <div class="grid-element">
    🇳🇿 (New Zealand)
  </div>
  <div class="grid-element">
    🇵🇦 (Panama)
  </div>
  <div class="grid-element">
    🇵🇱 (Poland)
  </div>
  <div class="grid-element">
    🇷🇴 (Romania)
  </div>
  <div class="grid-element">
    🇷🇺 (Russia)
  </div>
  <div class="grid-element">
    🇸🇪 (Sweden)
  </div>
  <div class="grid-element">
    🇸🇬 (Singapore)
  </div>
  <div class="grid-element">
    🇸🇻 (El Salvador)
  </div>
  <div class="grid-element">
    🇹🇭 (Thailand)
  </div>
  <div class="grid-element">
    🇹🇷 (Turkey)
  </div>
  <div class="grid-element">
    🇺🇦 (Ukraine)
  </div>
  <div class="grid-element">
    🇺🇸 (United States)
  </div>
  <div class="grid-element">
    🇺🇾 (Uruguay)
  </div>
  <div class="grid-element">
    🇿🇦 (South Africa)
  </div>
</div>

If you bought the screencast and would like a shout-out here let me know and I will gladly post your name or @ or whatever you want right here.

## Episodes

Without further ado, here's the content:

### Episode 1: Intro

{% include youtube url="https://www.youtube.com/embed/ETDKqcJ_Lf4" %}

<small>
  <i class="far fa-calendar-alt"></i> Recorded: 2018/12/05<br>
  <i class="fas fa-stopwatch"></i> Duration: 08:20
</small>

We'll clone the starter files repo in preparation for working through the
course. We'll take a peek under the covers at and locally spin up
Captioned Image Uploader, the example Rails application that we'll be
deploying to Kubernetes throughout the rest of the course.

<h4 class="notoc">Show notes</h4>

<a href="https://cloud.google.com">Google Cloud signup</a>
<br />
<a href="https://github.com/abevoelker/Kubernetes-on-Rails-Starter-Files">Starter files GitHub repo</a>

### Episode 2: Introduction to Google Cloud

{% include youtube url="https://www.youtube.com/embed/_ViBaMSMtmM" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 25:40
</small>

We'll register for a Google Cloud account, create a project, and prep
for our application deployment by creating our database, our GKE cluster,
building and pushing our Docker image, and so on using both the GCP Web
console as well as the gcloud CLI.

<h4 class="notoc">Show notes</h4>

<a href='https://cloud.google.com/sdk/install'>Google Cloud SDK install instructions</a>
<br>
<a href='https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#gcp_resource_hierarchy_in_detail'>Google Cloud resource hierarchy</a>
<br>
<a href='https://cloud.google.com/container-registry/docs/quickstart#add_the_image_to'>Container Registry quickstart</a>
<br>
<a href='https://cloud.google.com/compute/docs/access/service-accounts?hl=en_US#usingroles'>Access scopes must match IAM role permissions ("You must set access scopes on the instance to authorize access.")</a>
<br>

<h4 class="notoc">Errata</h4>

<ul>
  <li>
    In the video I made a mistake when I untar'ed and installed
    <code>gcloud</code>
    to the
    <code>/tmp</code>
    directory.
    <strong>Don't do this</strong>
    because the installer will modify your shell's path to look in
    <code>/tmp</code>
    for
    <code>gcloud</code>
    . Instead untar and do the install from your home directory -
    that's where
    <code>gcloud</code>
    should live. If you already extracted + installed to
    <code>/tmp</code>
    it's not a big deal though, you can just reinstall.
  </li>
  <li>
    Turns out that when creating the GKE cluster, under "Advanced options"
    there is an "Enable VPC-native" checkbox you can check which will enable
    private IP networking. So if you do that you won't need to copy and paste
    the blob of CLI arguments to create the GKE cluster.
  </li>
  <li>
    At 17:58 we give the cluster user "Full" access to Storage; on review I
    don't believe we needed to modify that as later on in the series we will be
    creating a Service Account which will have the necessary Storage
    permissions.
  </li>
</ul>


### Episode 3: Introduction to Kubernetes concepts

{% include youtube url="https://www.youtube.com/embed/jJLxe9xfGO8" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 21:24
</small>

A guided talk through the fundamental Kubernetes resources that we'll
use to build our deployment. We'll learn about Pods, Deployments, Jobs,
CronJobs, Services, and Ingresses, and sketch a diagram of how they'll
all fit together to run our app.

<h4 class="notoc">Show notes</h4>

<a href='https://kubernetes.io/docs/concepts/workloads/pods/pod/'>Pods documentation</a>
<br>
<a href='https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment/'>Pod manifest example</a>
<br>
<a href='https://kubernetes.io/docs/concepts/workloads/controllers/deployment/'>Deployments documentation</a>
<br>
<a href='https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/'>Jobs documentation</a>
<br>
<a href='https://kubernetes.io/docs/concepts/services-networking/service/'>Service documentation</a>
<br>
<a href='https://kubernetes.io/docs/concepts/services-networking/ingress/'>Ingress documentation</a>
<br>

### Episode 4: Deploying our code

{% include youtube url="https://www.youtube.com/embed/IiBFIvk833M" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 34:39
</small>

We'll get kubectl installed and connected to our GKE cluster, start using
it to manipulate our cluster, write manifests for the Kubernetes
resources we'll need (Job, Deployment, Secrets, Service), and finally
create them to get our application up and running! 🤩

<h4 class="notoc">Show notes</h4>

* [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
  * [Secrets risks and details](https://kubernetes.io/docs/concepts/configuration/secret/#risks)
    of how they're stored in an etcd cluster

<h4 class="notoc">What we learned</h4>

* Installing `kubectl` with `gcloud components install`
* `gcloud container clusters get-credentials standard-cluster-1` to tell
  `kubectl` to use the GKE cluster named `standard-cluster-1`
* Kubernetes Jobs
  * Writing a manifest to run our database migration
  * Deleting a job
    ```
    kubectl 
    ```
* Kubernetes manifests
  * How the `template:` key defines a Pod template for many different
    resource types
* `gcloud container images list` to list available Docker images
* `gcloud sql instances list` to get private IP address of SQL instance
* `gcloud sql users list --instance=captioned-image-db` to get list of SQL
  users for instance
* `gcloud sql users set-password postgres --password=foobar` to change
  `postgres` user password to `foobar`
* Kubernetes Secrets
  * How to reference in manifests
  * 12:15 How to create:
    ```
    kubectl create generic app-secrets --from-literal=DATABASE_URL=postgres://...
    ```
  * 13:38 How to edit existing with
    ```
    kubectl edit secret app-secrets
    ```
  * They're stored encoded with base-64
    * 19:30 Encoding plaintext into base-64 and copying to clipboard on
      Linux CLI using
      ```
      echo -n "whatever" | base64 --wrap=0 | xclip
      ```
* `kubectl` commands
  * `kubectl get jobs` to list jobs (add `-w` flag to watch and update on
    changes)
  * `kubectl get pods` to list pods
  * `kubectl logs db-migrate-qbxh6` to view logs (add `-f` flag to follow
    logs and update on changes)
  * `kubectl delete jobs/db-migrate` to delete `<resource_type>/<resource_name>`
* Kubernetes Deployments
  * How to write manifest
  * Different strategies, surge, and unavailability settings
  * How the selector makes the Deployment apply to Pods with that label
  * Creating a Service for the Deployment using `kubectl expose`

<h4 class="notoc">Errata</h4>

* 18:15 I said you could just update a Job's manifest and re-apply it and it
  will fix itself. This is true of most resource types however I think this
  is actually not the case with Jobs - you have to delete the job and
  recreate it.

<h4 class="notoc">Addenda</h4>

* At 31:35 we look at the logs for the running Rails server container,
  however you only see the Puma startup output. This is because the rest of
  the output is being written to a log file instead of output to STDOUT which
  is what the `kubectl logs` command is reading from. I didn't bother in the
  screencast but we could change this behavior in Rails 5 by setting the
  `RAILS_LOG_TO_STDOUT` environment variable. Interestingly in my experience
  Stackdriver (GCP's logging + monitoring solution, which we also didn't
  explore) seems to be smart enough to read from the log file so it's not a
  big deal.
* One other command I forgot to mention that is pretty neat is
  [`kubectl scale`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#scale)
  which lets resize the number of Pods in the Deployment without having to
  edit and re-apply a manifest. Useful for quickly scaling up if you're
  experiencing sudden load. Try it out!

### Episode 5: Fixing image upload using Google Cloud Storage

{% include youtube url="https://www.youtube.com/embed/iw5jJdmsH68" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 14:45
</small>

It's alive! 😍 But it's got a problem. 😭 We'll fix an issue with image
uploads by setting up Google Cloud Storage. Along the way we'll learn
how to use IAM Service Accounts and how to pop a remote Rails console.

<h4 class="notoc">Show notes</h4>

<a href='https://github.com/renchap/shrine-google_cloud_storage'>Shrine Google Cloud Storage plugin</a>
<br>
<a href='https://gist.github.com/abevoelker/6ff94c2208f20f30d3b3cbfe9c263ff6'>Shrine initializer code gist</a>
<br>

<h4 class="notoc">What we learned</h4>

* [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#exec)
  * Opened a remote Rails console
* Google Cloud Storage
* Kubernetes Secrets
  * Creation and editing
* Google Cloud IAM Service Accounts, Roles

### Episode 6: Ingress, domain name, and HTTPS!

{% include youtube url="https://www.youtube.com/embed/JcxmzLPm97A" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 30:47
</small>

So far we've been accessing our application directly over an internal
Service. We'll replace this with a more scalable solution by creating
our first Ingress, giving it a domain name, and getting a TLS certificate
through Let's Encrypt to enable HTTPS.

<h4 class="notoc">Show notes</h4>

<a href='https://www.duckdns.org/'>Duck DNS</a>
<br>
<a href='https://github.com/jetstack/cert-manager'>cert-manager</a>
<br>
<a href='https://github.com/ahmetb/gke-letsencrypt/issues/28#issuecomment-448036142'>My cert-manager v0.5.2 bug workaround</a>
<br>
<a href='https://letsencrypt.org/'>Let's Encrypt</a>
<br>
<a href='https://docs.helm.sh/using_helm/#installing-helm'>Helm installation</a>
<br>
<a href='http://ipv6-test.com/validate.php'>IPv6 website validation</a>
<br>

<h4 class="notoc">What we learned</h4>

* Kubernetes Ingress
  * Writing a manifest
  * Connecting to a service port
  * Assigning a global static IP
  * Authoring hostname and path rules
  * TLS configuration
* Helm package installation
* cert-manager
  * Issuer resource type
  * Certificate resource type
  * Annotating Ingresses to do ACME HTTP01 Let's Encrypt dance
    * How cert-manager modifies our Ingress to make `/.well-known/acme-challenge` path available to Let's Encrypt
* `kubectl get` shortnames (`kubectl get svc` vs `kubectl get services`)
* GKE Ingress specifics
  * Need to make separate Ingress to support IPv6
  * IPv6 Ingresses are free
  * 28:28
    [GKE Ingress](https://github.com/kubernetes/ingress-gce#ingress-cannot-redirect-http-to-https)
    can't force TLS - use
    [rack-ssl-enforcer gem](https://github.com/tobmatth/rack-ssl-enforcer)
    or your reverse proxy config if you're using say, nginx
* 27:09 Grouping multiple related resources into a single manifest
  [is a best practice](https://kubernetes.io/docs/concepts/configuration/overview/#general-configuration-tips)

<h4 class="notoc">Addenda</h4>

* I knowingly say "TLS certificate" instead of the more correct "X.509
  certificate" for simplicity's sake. Let's Encrypt uses the same wording
  on their site so I think that's okay.
* One thing I wanted to mention but forgot to in the episode is that we're
  using the
  [HTTP-01 ACME challenge type](https://letsencrypt.readthedocs.io/en/latest/challenges.html#http-01-challenge)
  which is the only challenge type we can use with a free Duck DNS domain
  name. However there is also a
  [DNS-01 challenge type](https://letsencrypt.readthedocs.io/en/latest/challenges.html#dns-01-challenge)
  which responds to challenges by creating TXT records. In my experience the
  DNS-01 challenge type works a lot smoother with cert-manager than the
  HTTP-01, and it also enables the creation of wildcard certificates. We
  couldn't do this in the screencast however because it would require viewers
  to buy a domain name and set up GCP Cloud DNS as the DNS provider.
* Interestingly, the GKE Ingress
  [doesn't even read the `hosts` field](https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl#the_hosts_field_of_an_ingress_object)
  of the `tls` spec, however it is needed by cert-manager to make the Let's
  Encrypt request.
* At 13:17 I mentioned we're creating a Kubernetes resource in the
  `kube-system` namespace. I probably should've used this as an opportunity
  to talk a bit more about namespaces and how they can be used to separate
  applications. So instead I encourage you to read
  [the documentation on them](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
  yourself. One handy flag worth mentioning is `--all-namespaces`; for instance
  to see all the pods running in your cluster you can do:

  ```
  kubectl get pods --all-namespaces
  ```

  This will be necessary if you ever have to debug cert-manager, for
  instance, *\*cough\** because it will start a pod in the `kube-system`
  namespace. When you want to then, say, inspect the logs of the pod you
  found you have to specify the namespace with `-n`; for example:

  ```
  kubectl logs cert-manager-7d4bfc44ff-tp9g6 -n kube-system -f
  ```
* 20:17 regarding "self check failed," that means that cert-manager did a
  pre-test to see if the domain is reachable before handing things off to
  Let's Encrypt. It's meant to save you from prematurely making requests to
  Let's Encrypt that it thinks will fail to save you from getting
  rate-limited. Which is a neat idea,
  [except when it doesn't work](https://github.com/jetstack/cert-manager/issues/1157#issuecomment-448373488).
* For the most detailed list of limitations with GCP's Ingress, check out
  [its GitHub repo](https://github.com/kubernetes/ingress-gce)

### Episode 7: Boosting static asset performance using Cloud CDN

{% include youtube url="https://www.youtube.com/embed/RNUFXbcC24Q" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 23:00
</small>

Up until now we've been serving our static assets directly from our
Rails server (boo, slow!). We'll replace this with Cloud CDN
(hooray, fast!). To accomplish this we'll meet a new Kubernetes resource,
BackendConfig, and learn how to wire it up through a new Service port
and our Ingress.

<h4 class="notoc">Show notes</h4>

<a href='https://guides.rubyonrails.org/asset_pipeline.html#cdns'>Rails Asset Pipeline CDN docs</a>
<br>
<a href='https://cloud.google.com/cdn/docs/'>Cloud CDN docs</a>
<br>
<a href='https://cloud.google.com/kubernetes-engine/docs/concepts/backendconfig'>BackendConfig docs</a>
<br>
<a href='https://latency.apex.sh/'>Apex.sh global latency testing tool</a>
<br>
<a href='https://console.cloud.google.com/net-services/cdn/list'>Cloud CDN in the web console</a>
<br>


### Bonus Episode 1: Provisioning cloud resources with Terraform

{% include youtube url="https://www.youtube.com/embed/E2xHG0UdovE" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 01:33:19
</small>

While building our application, we provisioned GCP resources using
the web console and the gcloud CLI. We'll investigate using
Terraform to replace our manual work with declarative templates
which will make our deploys repeatable, versionable, and all the
other benefits of moving infrastructure management to code.

<h4 class="notoc">Addenda</h4>

* This episode was recorded before Terraform 0.12 was released. With 0.12 you no longer need to enclose all attributes in quotes and there are now a few more types of variables besides strings.
* The SQL user we are creating has database superuser privileges. You may want to create a user with less privileges for your own app.
* The different cluster types are referred to as regional or zonal, which [you can read more about here](https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters), and more about how to create the different types on GCP's "[creating a cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster#zonal)" guide.
* There is a Kubernetes provider and a resource for Secrets. This is a much handier way to set the app-secrets Secret value, and this is the way I do it in the Helm episode. See the Starter Files repo for the .tf Terraform config.

<h4 class="notoc">Topics for further exploration:</h4>

* [Terraform Kubernetes provider getting started](https://www.terraform.io/docs/providers/kubernetes/guides/getting-started.html)
* [Example creating a Kubernetes Secret for storing a GCP service account key](https://www.terraform.io/docs/providers/google/r/google_service_account_key.html)
* [Terraform modules](https://www.terraform.io/docs/modules/index.html)
* [Terraform remote state](https://www.terraform.io/docs/providers/terraform/d/remote_state.html)


### Bonus Episode 2: Charting our app with Helm

{% include youtube url="https://www.youtube.com/embed/Lg8CRMkv7C4" %}

<small>
  <!--<i class="far fa-calendar-alt"></i> Recorded: 1970/01/01<br>-->
  <i class="fas fa-stopwatch"></i> Duration: 01:04:42
</small>


We get sick of running `kubectl apply` over and over and decide
to use Helm, Kubernetes's package manager, to template and package
up our app into a reusable chart for simplified app deployment.

<h4 class="notoc">Show notes</h4>

**Reminder: Steps to provision a brand new GCP project using our Terraform config:**

1.  Create GCP project
2.  Enable [Cloud Resource Manager API](https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)
3.  Enable [Compute Engine API](https://console.cloud.google.com/apis/api/compute.googleapis.com/overview) (needed to import VPC default network before plan/apply runs)
4.  [Create a service account](https://console.cloud.google.com/iam-admin/serviceaccounts) for Terraform to use with project owner permission
5.  Generate a key for the service account, copy the .json file to `provision/keyfiles/keyfile.json`
6.  Update the `terraform.tfvars` file to set variables to your own values
7.  `cd` to the provision directory, run `terraform init` to initialize terraform provider plugins
8.  Import the VPC default network with `terraform import google_compute_network.vpc_default default`
9. Now you can `terraform plan -out /tmp/plan` and then `terraform apply /tmp/plan`

Note: If you get an error when performing terraform plan/apply in the beginning like `Failed to create subnetwork. Please create Service Networking connection with service 'servicenetworking.googleapis.com'` you may need to wait several minutes for the networking resources to fully initialize, then do `terraform taint random_id.db-instance` and redo `terraform plan`/`apply` to recreate the SQL instance.

<h4 class="notoc">Useful links</h4>

* [Go text/template template reference](https://golang.org/pkg/text/template/)
* [Hugo, a static site generator written in Go](https://gohugo.io/templates/introduction/) - has useful explanations and tips on Go templating
* [Helm quickstart](https://helm.sh/docs/using_helm/#quickstart)
* [Helm Charts documentation](https://helm.sh/docs/developing_charts/)
* [Chart Development Tips and Tricks](https://helm.sh/docs/charts_tips_and_tricks/)
* [The Chart Best Practices Guide](https://helm.sh/docs/chart_best_practices/#the-chart-best-practices-guide) - Making our captioned-images chart conform to best practices is left as an exercise to the reader 😁
* [GKE guide: Using Google-managed SSL certificates](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs)
