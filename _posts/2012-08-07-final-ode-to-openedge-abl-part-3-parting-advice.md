---
layout: post
title: "Final Ode to OpenEdge ABL Part 3: Parting Advice"
date: 2012-08-07 20:00
comments: true
facebook:
  image: yao_ming_progress_openedge.jpg
excerpt_separator: <!--more-->
permalink: final-ode-to-openedge-abl-part-3-parting-advice/
---

![Yao Ming laughing at OpenEdge](/images/yao_ming_progress_openedge.jpg "OpenEdge? Fuck that shit lol")

In [part 1][1] of this series I demonstrated how to write Ruby code against an
OpenEdge database using the JDBC driver and DataMapper ORM, and in [part 2][2]
I showed how to take advantage of this to rapidly prototype a RESTful Web
service / JSON API for the canonical `sports2000` OpenEdge database using
Ruby and Sinatra.

For the final post in this series, I promised to offer some advice to
Progress Software Corporation (PSC) on how to advance the OpenEdge ecosystem.

In the spirit of the words "let the dead bury the dead" I'm going to keep this
short as I'm skeptical that this post stands much chance of effecting any
changes.

<!--more-->

## The Golden Goose

What PSC needs to do is to decide which of the nasty siamese twins is their
golden goose - OpenEdge the database, or ABL the programming language. I'm
assuming it's the database because ABL mainly exists to query it. My advice is
to focus on fluffing up the goose, and give the axe to the ugly duckling (or
gosling, I guess).

## Improve OpenEdge SQL

First, the database is not nearly powerful enough to warrant requiring its
own grammar.  I would drastically improve support for the lingua franca of
relational databases, SQL, by incrementing the SQL engine to a newer
SQL standard.  OE features that don't fit into a recent standard can go into
vendor-specific SQL grammar (like everyone else does).  This would make
adding support for OpenEdge databases to popular programming languages very
easy.

## Deprecate ABL

Trying to turn ABL into a full-featured programming language
was and continues to be a mistake on the part of PSC.  They simply can't
iterate fast enough to keep ABL up to date with the pace of innovation in the
rest of the software industry - and that's understandable.

To put it bluntly I think ABL should be deprecated. The CLR bridge is the
smartest thing that PSC did to the language, and instead of continually
trying to play catch-up with developing their own language, they should embrace
language openness by doing a few things:

*  Support [Mono][1] as a .NET development target, which would allow writing
   .NET code in the AVM for Unix systems.  This would allow programmers to
   use a much stronger language like C# for general purpose development. This
   is already a viable option for Windows development, but not currently a
   general-purpose solution due to the lack of Mono support.
*  Open source the ABL Virtual Machine (AVM). This would give the ultimate in
   extensibility to ABL coders by allowing them to code in any language as
   long as it compiles down to AVM bytecode.
*  Open source the ABL language and compiler tools (predicated on last point
   due to AVM bytecode dependency). This would allow the community to fix
   bugs and add features to the ABL language without having to wait for PSC.

## Marketing Reboot

Drop the "business language" bullshit. Such a concept doesn't exist. If it
did, the end users would be writing the code themselves.  Same goes for the
silly "4GL" label of false superiority.  Coupling a programming language
to a database doesn't make the language look more advanced, it makes it look
ridiculous.

The big push on marketing OpenEdge for "the cloud" is a joke. "Cloud" apps
are all about services / APIs, which OpenEdge fails at; it doesn't even
have REST support yet.  The only Web service it supports is SOAP which is
disgustingly ancient and involves a huge amount of glue code, such as
generating WSDLs and using the ProxyGen to prepare more Java or .NET
interface glue code. If your process is this obsolete and complicated then
I don't think you're "cloud"-ready.

Also, multi-tenancy isn't a new feature to most
databases and not really much to brag about - I know for a fact that
Postgres has supported them for many years (they call them "schemas"). I
also wouldn't consider multi-tenancy to be any kind of requirement for
writing a "cloud" app - in fact I've seen convincing arguments *against* using
it for such services. So hold off on the champagne.

Quite simply, PSC has historically spent way too much on marketing and too
little on actual engineering... that needs to change drastically.

## Conclusion

This series has been cathartic.  I feel like I have some closure on my past
now, and can completely let go of the mental baggage I've been carrying of my
depraved interactions with OpenEdge.

I plan to continue evolving as a software developer by moving onto more
functional pastures, focusing on Clojure at the moment.  So far it seems a
very good intersection of the "pureness" that I loved about learning LISP
(Scheme) in school but with actual practical capabilities rather than being
so utterly academic.  Of course Ruby will maintain a soft place in my heart,
and continue to pay my bills. Stay tuned!

[1]: /final-ode-to-openedge-abl-part-1-a-ruby-adapter-is-born/
[2]: /final-ode-to-openedge-abl-part-2-ruby-helps-you-rest-easy/
[3]: http://mono-project.com
