---
layout: post
title: "Final Ode to OpenEdge ABL Part 3: Parting Advice"
date: 2012-07-27 18:21
comments: true
---

In [part 1][1] we learned how to write Ruby code against an OpenEdge database
using the JDBC driver and DataMapper ORM, and in [part 2][2] we learned how to
take advantage of this to rapidly prototype a RESTful Web service / JSON
API for the canonical `sports2000` OpenEdge database using Ruby and Sinatra.

For the final post in this series, I promised to offer some advice to
Progress Software Corp. on how to advance the OpenEdge ecosystem.

In the spirit of the words "let the dead bury the dead" I'm going to keep this
short as I don't have any clout in the OpenEdge community so I don't think my
words have much traction; they will probably fall on deaf ears.

## ABL (language)

### Purpose

Why does ABL even exist?  Is it not just a special language for talking to an
OpenEdge database?  Is OpenEdge a powerful enough database that it cannot be
properly described using SQL and must use it's own grammar?  I don't think so.

ABL is only still around because of the inertia of all the legacy apps that
sprung up 20 years ago when it was more of a revolutionary concept for
prototyping CRUD apps.  These apps and their children are still around due to
the very effective vendor lock-in of a closed language *and* database. The
problem comes when users want their ancient apps to do something more modern;
how do you get that 

The problem is interfacing with a closed language is difficult; PSC has
historically seemed determined to keep trying to add on more features to ABL,
rather than opening up the ecosystem for external interfaces (although this
has changed recently now with the CLR bridge to .NET applications).

It's mutated from a simple database querying language
with simple report/display properties into a frankenstein

### Future

ABL is already way behind other languages and it's pointless to try and copy
a bunch of features of other languages to try and get it caught up. The CLR
bridge was an excellent step forward, but it isn't enough.

If I were given the decision of what to do with ABL, I would cut my losses and
do the following:

1) Support [Mono][1] as a .NET development target, which would allow writing
   .NET code for Unix systems.
2) Open source the ABL Virtual Machine (AVM). This would give the ultimate in
   extensibility to ABL coders, by allowing them to code in any language as
   long as it compiles down to AVM bytecode.

If those things were done, I would put a freeze on ABL "features" and only
support bugfixes.


## OpenEdge (database)

### Purpose

I'm not a very big fan of the database, but I'm not a DBA so maybe I'm missing
something.

### Future

OpenEdge should use the lingua franca of relational databases, which is SQL.
Besides vendor lock-in there is no reason why it can't support it, and it
would drastically increase interoperability with other programming languages.

If I were running the company, I would throw most of my OpenEdge resources at
improving the internals of the database and the SQL engine, and freeze
development of the ABL database engine and programming language.

[1]: /final-ode-to-openedge-abl-part-1-a-ruby-adapter-is-born/
[2]: /final-ode-to-openedge-abl-part-2-ruby-helps-you-rest-easy/
[3]: http://mono-project.com
