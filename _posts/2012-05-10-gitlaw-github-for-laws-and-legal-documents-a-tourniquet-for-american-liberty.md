---
layout: post
title: "GitLaw: GitHub for Laws and Legal Documents - a Tourniquet for American Liberty"
date: 2012-05-10 04:23
comments: true
facebook:
  image: house_of_representatives_chamber_octocat.jpg
excerpt_separator: <!--more-->
permalink: gitlaw-github-for-laws-and-legal-documents-a-tourniquet-for-american-liberty/
---

[![]({{ site.url }}/images/house_of_representatives_chamber_octocat_thumb.jpg)]({{ site.url }}/images/house_of_representatives_chamber_octocat.jpg)

<p class="message" markdown="1">
**Update**: This post received a lot of [attention on Hacker News][6]. Please
also visit there to read many insightful comments!
</p>

<p class="message" markdown="1">
**Update 2**: Apparently this post also provided [some inspiration][7] for a
TED Talk entitled "[How the Internet will (one day) transform government][8]" by
[Clay Shirky][9]. Check it out!
</p>

It's no secret that most Americans hate the members of our legislative branch.
[Polls show][1] that **79%** of Americans currently disapprove of the job that
Congress is doing (only 14% approve).  I can only speak for myself,
but the disdain I feel for Congress is due to suspicion of a combination of
malfeasance, misfeasance and nonfeasance.  I simply don't trust them to
represent me, and I don't think most Americans do, either.

<!--more-->

How can we restore public trust in Congress?  The first solution that comes to
mind would probably get me arrested or put on some secret government list
(tinfoil hat securely in place!), so I'll just stick to non-revolutionary
solutions.

One thing that I think could help would be making Congress's primary job - the
creation and passage of legislation - a more transparent process.  It turns out
that Congress tends to [rush bills through][2] to a vote shortly after they are
introduced, without giving an adequate amount of time for the public - or even
themselves - enough time to digest their contents.  If Congress is unable to
properly execute their most basic duty on their own, why not crowd source it?

## A GitHub for Laws and Legal Documents

Imagine a public system like GitHub but instead of source code being tracked,
legal documents such as bills/laws are tracked (and just like GitHub, versioned
in git). Imagine if, before any bill is introduced to Congress, its contents
were posted on this publicly available medium with adequate time before a vote?

What if any proposed amendments to legislation were posted publicly as pull
requests?

What if *anyone* could write amendments to existing laws, or even entirely
new laws and propose them to Congress (or lobby their Congressperson to
introduce it) using pull requests?

What if you could fire up `git blame`, and see who is responsible for writing
each individual line of a bill?  Think of how easy it would be to track down
those pork barrelers (or worse), especially if the *actual* writer of the bill
was tracked, and not just the bill's congressional sponsor (grr... lobbyists).

Even something akin to GitHub Issues could be useful.  Say you spot an earmark
(or something worse) on line 122,567 of a bill.  You can then open an issue on
that specific line number with a description of what's wrong.  You can then
appeal to your representative about it or use social media to draw attention
to it.

## Version Control for Legal Documents

I have no idea how legal documents are typically digitally stored, but the
best format for version control is something plain text and diffable;
binary formats don't work well (e.g. no Microsoft Word, Adobe PDF, etc.).

It looks like there is an existing project called [Legal-RDF][3] that was
created to add semantic data to digital legal documents, but it's XML and
therefore not very readable.

I would instead suggest creating a new markup language for legal docs that
would work similar to Markdown. One interesting project that I've seen take
this DSL approach is [Fountain][4], which is a markup syntax for screenplays.

Of course, a site like GitLaw wouldn't have to have One Format to Rule Them
All (much the same as GitHub supports many different programming languages).
But having a common readable base format available to start with would
decrease activation energy needed to get started.

## Side Effects

### Beyond Congress

All of the above could apply not only to Congress, but to basically any
lawmaking body - state or local government, or international governments. In
fact, because US states often duplicate a lot of their laws (with minor
changes), it would make it very easy for a state like Wisconsin to copy that
hot new piece of legislation that Texas came up with by forking their repo.
This process would also make it easy to track any changes that those brilliant
Texas representatives come up with that Wisconsin might want to apply to its
own copy.

### Personal Legal Docs <3 git

Being able to easily store and share any legal document would also be nice for
not just lawmaking bodies, but also individuals. For example, if I had a will
or power of attorney documents, I could store them in a private git repo that
could be opened upon my demise or incapacitation. The security of the git DAG
means that if I shared the repo with a third-party (such as an attorney), the
integrity of the repo could be verified by comparing them (i.e. the SHA-1's
make it quite tamper proof). Or, even if I didn't trust anyone, if my dying
words were the SHA-1 of the head commit that would also suffice for verifying
the integrity of the repo. :-)

### Decreased Lawyer Coupling

This might be a bit of a stretch, but the ease of sharing that git enables
could also decrease the coupling that individuals currently have on attorneys
for creating legal documents.  For example, if the basic template for a
document like a will could be extracted, then someone else could use it
to create their own without having to hire an attorney, or at least reduce
how much time an attorney would need to spend on the task by doing some
legwork ahead of time (at least within the same legal area, e.g. US state).
It wouldn't obviate the need for attorneys, but would hopefully make them
less necessary.

I wonder what effect having the common man more involved with writing legal
documents would have?  Would it feed into itself, and make legal documents
more approachable - for instance, inspiring a move to more
[plain English legal wording][5]?

## Conclusion

This post probably illustrates how much I love git and GitHub moreso than
providing an actual actionable strategy for improving Congress.  I'm not
very knowledgable about legal matters, so I'm sure even a paralegal could
rip this stuff to shreds.  But it's fun to dream.  Tell me how crazy I am
in the comments section!

[1]: http://www.realclearpolitics.com/epolls/other/congressional_job_approval-903.html
[2]: http://readthebill.org/rushed/
[3]: http://www.hypergrove.com/legalrdf.org/LegalMarkup.html
[4]: http://fountain.io/
[5]: http://www.amazon.com/Legal-Writing-Plain-English-Publishing/dp/0226284174
[6]: http://news.ycombinator.com/item?id=3967921
[7]: http://blog.ted.com/2012/09/25/further-reading-in-github/
[8]: http://www.ted.com/talks/clay_shirky_how_the_internet_will_one_day_transform_government.html
[9]: http://www.shirky.com/
