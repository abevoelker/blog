---
layout: post
title: "OpenEdge ABL Utility: Get Program Parameters (Main Block) from R-code"
date: 2010-10-02
comments: true
categories: 
---

I have recently been working on a new compiler interface and backend for my
workplace. I am pretty much done with it at this point - and the adventure
is worthy of it's own blog post - however, I thought I would share a little
script with the world that might be useful to others.

Basically, I wanted to table-ize as much meta information about a program as
possible when it gets compiled.  One piece of information I wanted is the main
block parameters of a program (e.g. `DEFINE INPUT PARAMETER ipcString AS
CHARACTER.` at the top of the program).  I mean, how cool would it be to do a
simple check on `RUN` statements to see if they will fail at compile-time (by
checking existing compile snapshots of the program referenced by the `RUN`;
assuming of course that the `RUN` statement can be evaluated at compile-time)?

<!--more-->

I started by checking the OpenEdge handbook, expecting to see something useful.
Nope, nothing like that in the `RCODE-INFO` handle section.  Nope,
`INTERNAL-ENTRIES` requires me to run the program (unrelated thought: how is
this even useful, anyway?).

Hmm, guess I'll check the `XREF-XML` output... okay, this isn't good.  Main
block `PARAMETER`s do not show up as anything that allows you to identify them
as a `PARAMETER`.  They actually look identical when compared to a plain 
`DEFINE VARIABLE` statement! So that's no good either.  (Note: this is not an
issue with internal procedures' parameters)

Unwilling to give up, I ended up submitting the question to Progress Corp.
directly, who informed me that I could actually analyze the object (.r) code
directly in my "favorite text editor" and the `PARAMETER`s would be visible
near the top of the binary gibberish. I tried to get them to give me an
algorithmic way to pull this information out of the binary gobbledy-gook, but I
was not provided with such info. They also told me that they are unable to
provide me with a utility written in OpenEdge ABL to do this with, since it is
an epic fail when it comes to parsing binary files (this is really amazing
information, considering it is a 4GL, fourth-generation language and all!).

So, I went ahead and used Perl (the programmer's swiss army knife) and a best
guess at an algorithmic way to pull this information.  Here is the script I
came up with:

{% gist 581127 getRcodeParams.pl %}

As noted in the script's "notes" section, this has only been tested on OpenEdge
10.1C code compiled on Unix. Also noted are the fact that there appears to be
other useful info in there, like `TEMP-TABLE` and `FUNCTION` definitions. 

A future version could be created to pull this information as well. Perhaps it
would be a good opportunity for me to practice some Perl (dare I imagine, maybe
even some object-oriented Perl?). I made a
<a href="http://gist.github.com/581127">gist</a> of it on github so that it can
be version controlled, so look for any updates on there first.

Before anyone brings it up, I did consider using
<a href="http://www.joanju.com/proparse/">Proparse</a> (for the entire
project, actually) but I considered the API a bit too unwieldy for me to pick
up in the limited timeframe required for this project (I will talk more about
that when I write the full adventure posting). I would really like to explore
it since compilation is a topic that interests me quite a bit, but I will
probably spend more time on learning Ruby and coming up with a Progress
migration plan for my employer...
