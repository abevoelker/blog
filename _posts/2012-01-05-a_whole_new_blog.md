---
layout: post
title: A Whole New Blog!
date: 2012-01-05
comments: true
facebook:
  image: octopress.png
excerpt_separator: <!--more-->
permalink: a_whole_new_blog/
---

![Octopress logo]({{ site.url }}/images/octopress.png)

Welcome to my new blog design! I've migrated my blog posts from Wordpress
over to [Octopress][], which is a custom version of [Jekyll][] with a sensible
default style and some additional plugins. It was extremely fast to get up
and running - after cloning the [git repo][Octopress git] you already have a
working site!

Octopress/Jekyll are static site generators, meaning that there is no
server-side rendering that takes place when you are viewing these pages -
it's all HTML/CSS/JavaScript! The great thing about this is that pages
load very fast, especially under heavy load.

<!--more-->

For syntax highlighting they use the excellent [Pygments][] library, which
unfortunately didn't already have a lexer for OpenEdge ABL / Progress, so I
had to [write one][ABL Lexer] myself. This is the same library that GitHub
uses for syntax highlighting, so if Pygments would hurry up and merge my
old pull request there would be highlighting support on there too.

I initially tried blogging with [nanoc][], which worked well coding-wise, but
since it doesn't come with any default styles I was totally stuck as I simply
have no taste for design and am very bad at doing CSS from a blank slate. From a
functional perspective, I would much rather be using nanoc as the compile/route
pipeline you are given is very powerful for designing the app. Jekyll
can't really compare to it; if you have to do anything advanced you have
to hack away at core files that could be blown away in an update or write
a plugin for it (there aren't very many existing plugins). In nanoc most of
these things can be accomplished using the rendering pipeline and plain old
Ruby gems.

If I had a ton of time I would take the default Octopress style and port it
to nanoc! In any case, I am not a prolific blogger so the content matters
much more than what's powering the blog.

## What else changed?

I haven't kept all of the postings; I've deleted a couple that were kind
of boring. I've also cleaned up some of the wording/grammar on some of the
existing posts as I passed by (nothing to change the content meaning, though).

Another thing is that I changed the blog address to use a [subdomain][blog]
instead of a [subdirectory][old_blog] off of abevoelker.com. This is so that in
the future my blog could be hosted separately from my root domain, for example
on [GitHub Pages][] or [Heroku][]. This mostly comes out of the fact that I
really want to get off of Dreamhost (despite being a customer since 2006) due
to a burst of constant VPS outages several months ago. I'll probably either
end up on [Linode][] VPS or [Amazon EC2][], depending on which I work out as
being the cheapest for what I need.

## The Source

The source for this blog will be kept on [GitHub][blog source]. The source for
my abandoned nanoc migration attempt is also on [GitHub][nanoc blog source].
The source code for the OpenEdge ABL Pygments lexer is on
[BitBucket][ABL Lexer].

[Octopress]: http://octopress.org/
[Octopress git]: https://github.com/imathis/octopress
[Jekyll]: https://github.com/mojombo/jekyll
[Pygments]: http://pygments.org/
[ABL Lexer]: https://bitbucket.org/abevoelker/pygments-main/overview
[nanoc]: http://nanoc.stoneship.org/
[blog]: http://blog.abevoelker.com/
[old_blog]: http://abevoelker.com/blog/
[GitHub Pages]: http://pages.github.com/
[Heroku]: http://www.heroku.com/
[Linode]: http://www.linode.com/
[Amazon EC2]: http://aws.amazon.com/ec2/
[blog source]: https://github.com/abevoelker/blog-octopress
[nanoc blog source]: https://github.com/abevoelker/blog-nanoc
