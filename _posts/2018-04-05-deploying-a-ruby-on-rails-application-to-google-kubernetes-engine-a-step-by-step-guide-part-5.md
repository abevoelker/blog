---
layout: post
title: "Deploying a Ruby on Rails application to Google Kubernetes Engine: a step-by-step guide - Part 5: conclusion, thank you, further topics and Rails extras"
date: 2018-04-05 00:04
comments: false
og_image: "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/congratulations.gif"
excerpt_separator: <!--more-->
---

[{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/congratulations.gif" alt="Neon Genesis-style congratulations" %}]({{ page.url }})

<div class="alert alert-secondary" markdown="1">
<small>Welcome to the last post of this five-part series on deploying a Rails application to Google Kubernetes Engine. If you've arrived here out-of-order, please start at [part one](/2018-04-05/deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide-part-1/).</small>
</div>

Congratulations, we've finished deploying the application!

## Conclusion

Docker was revolutionary, but it mainly gave us low-level primitives without a way to assemble them for production-ready application deployments. I hope through this tutorial I've shown that Kubernetes meets that need by providing the abstractions that let us express application deployments in logical terms, and that GKE is an excellent managed Kubernetes solution.

I'll close with a great thought by Kelsey Hightower, in that Kubernetes isn't the final word in a story that doesn't end:

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Docker wrote the developer story. Kubernetes expanded the narrative and added some new chapters, but the story has no ending.</p>&mdash; Kelsey Hightower (@kelseyhightower) <a href="https://twitter.com/kelseyhightower/status/969611963876622336?ref_src=twsrc%5Etfw">March 2, 2018</a></blockquote>

## Thank you

HUGE thanks to my reviewers, Daniel Brice ([@fried_brice](https://twitter.com/fried_brice)) and Sunny R. Juneja ([@sunnyrjuneja](https://twitter.com/sunnyrjuneja)) for reviewing very rough drafts of this series of blog post and providing feedback. 😍 They stepped on a lot of rakes so that you didn't have to - please give them a follow! 😀

Any mistakes in these posts remain of course solely my own.

<!--more-->

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

[Helm is Kubernetes's official package manager](https://helm.sh/). We touched on using Helm when we installed chart-manager, but it's worth exploring further. Helm can also be useful for organizing your own project's resources. It also comes with templating so if nothing else it can replace the `envsubst` solution we used earlier.

### Kubernetes manifest templating

Speaking of templating, I mentioned [in a footnote](/2018-04-05/deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide-part-2/#fn:k8s-templating) earlier that there are many solutions worth investigating. You should try to find one that fits your workflow the best.

### Firewalls

We didn't touch on [configuring firewalls](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod#firewalling), but that should be investigated for a production GKE cluster.

Kubernetes itself also has a [Network Policy feature](https://github.com/ahmetb/kubernetes-network-policy-recipes) that may be worth checking out.

### AppEngine

GKE and Kubernetes give you a lot of power for deploying and managing your application, but also a lot of complexity. If you have a really simply application, it's worth considering simpler PaaS-style alternatives.

In this vein GCP has [AppEngine](https://cloud.google.com/appengine/), which supports several programming languages upfront as well as custom workloads using containers ([AppEngine Flex](https://cloud.google.com/appengine/docs/flexible/)). [Here's a nice article](https://medium.com/google-cloud/app-engine-flex-container-engine-946fbc2fe00a) that can help one decide whether to use App Engine Flex or GKE.

## References

Here are some miscellaneous links I found useful while learning Kubernetes/GKE that I couldn't find a relevant place to link to earlier in this post.

[Code Cooking: Kubernetes](https://medium.com/google-cloud/code-cooking-kubernetes-e715728a578c)

[Managing Rails tasks such as 'db:migrate' and 'db:seed' on Kubernetes while performing rolling deployments](https://blog.bigbinary.com/2017/06/16/managing-rails-tasks-such-as-db-migrate-and-db-seed-on-kuberenetes-while-performing-rolling-deployments.html)

[Global ingress in practice on Google Container Engine — Part 1: Discussion](https://medium.com/google-cloud/global-ingress-in-practice-on-google-container-engine-part-1-discussion-ccc1e5b27bd0)

[Kubernetes Engine Samples](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples)

[Understanding kubernetes networking: pods](https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727)

## Extras for Rails developers

{% asset "deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide/rails-logo.png" alt="Rails logo" %}

In the interest of keeping the tutorial as content-agnostic as possible I moved Rails-specific notes to the end. If you're a Rails developer and had some questions or concerns hopefully this section addresses them.

### Why an nginx reverse proxy?

Some folks will recommend configuring Rails to serve static assets, and [simply put a CDN in front](http://guides.rubyonrails.org/asset_pipeline.html#cdns) to cache assets so that only the first asset request (which actually hits Rails) is slow. However, I like that nginx reduces the need to have a bunch of Rack middleware (e.g. for [enforcing SSL access](https://github.com/tobmatth/rack-ssl-enforcer), [gzip-compressing requests](https://robots.thoughtbot.com/content-compression-with-rack-deflater), [aborting slow requests](https://github.com/heroku/rack-timeout)), and supports features Rails/Rack doesn't have quite yet (like [on-the-fly brotli compression](https://github.com/google/ngx_brotli)), as well as letting you opt-out of using a CDN while still having decent asset load performance.

The cost of course is running another container in each application server Pod. I think it's worth that marginal extra cost in resources and deployment complexity, but I appreciate others won't.

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
