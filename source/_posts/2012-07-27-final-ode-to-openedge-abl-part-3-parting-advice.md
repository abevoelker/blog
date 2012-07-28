---
layout: post
title: "Final Ode to OpenEdge ABL Part 3: Parting Advice"
date: 2012-07-27 18:21
comments: true
---

In [part 1][1] I demonstrated how to write Ruby code against an OpenEdge
database using the JDBC driver and DataMapper ORM, and in [part 2][2] I
showed how to take advantage of this to rapidly prototype a RESTful Web
service / JSON API for the canonical `sports2000` OpenEdge database using
Ruby and Sinatra.

For the final post in this series, I promised to offer some advice to
Progress Software Corp. on how to advance the OpenEdge ecosystem.

In the spirit of the words "let the dead bury the dead" I'm going to keep this
short as I don't really belong to the community so am probably just wasting my
breath.

<!-- more -->

## Past / present (review)

Progress the database/language was created twenty-some odd years ago as a
probably then-revolutionary way to hammer out CRUD apps. The Progress
language had the neat feature of having the ability to query the database
baked into the language.  It also came with built-in display tools to make
it simple to present GUI interfaces and reports to the user.

They also spend plenty of money on marketing, advertising the language as
a "fourth-generation language (4GL)" and as a "business language", whatever
the hell either of those terms mean.  Their marketing machine also rebranded
the database to OpenEdge and the programming language to Advanced Business
Language (ABL) at some point.

OpenEdge is a locked-in platform.  Until very recently with the CLR bridge
opening up development with .NET, getting modern updates to the language
and databases has required appeals to PSC to please add a feature to the
language / database.  

## Future (suggested)

### ABL, the programming language

ABL is already way behind other languages and it's futile to try and keep
up with the software industry by trying to backport "popular" features into the
language. The CLR bridge was an excellent step forward, but it isn't enough.

If I were given the decision of what to do with ABL, I would cut my losses and
do the following:

*  Support [Mono][1] as a .NET development target, which would allow writing
   .NET code in the AVM for Unix systems.
*  Open source the ABL Virtual Machine (AVM). This would give the ultimate in
   extensibility to ABL coders by allowing them to code in any language as
   long as it compiles down to AVM bytecode.

If those things were done, I would put a freeze on advancing the ABL language
and only support bugfixes.  The language could actually be advanced through
community effort if the AVM was open source.

### OpenEdge, the database

I really don't see what's so great about the database, but I'm going to assume
that it's the golden goose that must be protected.

First, the database is not nearly powerful enough to warrant requiring its
own grammar.  I would switch to the lingua franca of relational databases,
SQL, and drastically improve the SQL engine to enable better interoperability
with non-ABL languages.

If this really is the golden goose, I would reallocate all my resources from
the ABL language to focus on improving the database internals.  This would be
quite a tall order though, as Postgres is already on course to become the
undisputed king of relational databases, and there are plenty of existing
NoSQL alternatives out there for most other use cases.

### Marketing

Drop the "business language" bullshit. Such a concept doesn't exist. If it
did, the end users would be writing the code themselves.  Same goes for the
arbitrary "4GL" label of false superiority.  Coupling a language to a database
doesn't make a language look more advanced, it makes it look ridiculous.

The big push for marketing for "the cloud" is a joke. If it isn't simple for
you to write an app as a service / API then it doesn't belong in the cloud.
And by the way, multi-tenancy isn't a new feature to most databases - I know
for a fact that Postgres has supported them for many years (they call them
"schemas").  And, in fact, I've seen some arguments against multi-tenancy
anyway.

## Conclusion

Now that I look things over, I can see why PSC has chosen the path they have
of trying to keep OpenEdge a locked-in system.  Any attempt at opening up a
large part of the system could lead it to collapse like a house of cards.

[1]: /final-ode-to-openedge-abl-part-1-a-ruby-adapter-is-born/
[2]: /final-ode-to-openedge-abl-part-2-ruby-helps-you-rest-easy/
[3]: http://mono-project.com
