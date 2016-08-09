---
layout: post
title: "Sick of Ruby, dynamic typing, side effects, and basically object-oriented programming"
date: 2014-06-29 15:30
comments: true
excerpt_separator: <!--more-->
permalink: sick-of-ruby-dynamic-typing-side-effects-object-oriented-programming/
---

This has been a long time coming. I had meant to write this post around the New Year, before the wave of [death of Ruby][avdi-ruby-demise] stuff and before DHH's "[TDD is dead][dhh-tdd-dead]" ruckus:

<blockquote class="twitter-tweet" lang="en"><p>I&#39;m officially fully jaded with Ruby. Amongst other things, sick of side effects and mutable state that force me to write so many unit tests</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/statuses/416592284298137601">December 27, 2013</a></blockquote>

I think subconsciously more and more people are figuring out something is wrong or lacking with Ruby development, but they are lashing out at the wrong things.  Oh, your Ruby app is a steaming pile of shit?  It's because you weren't diligent enough writing tests or you weren't following TDD principles closely enough.  Or you aren't knowledgable enough with design patterns to break it up into the right patterns.  Or you aren't following the [Single Responsibility Principle][SRP], or [SOLID][SOLID], or [Law of Demeter][law-of-demeter], yadda yadda.  Here, read this book on patterns or testing or OO design and get back to me when you reach enlightenment.

<!--more-->

<blockquote class="twitter-tweet" lang="en"><p>I literally do not know what OO, or especially OO design, really mean. I wasted so many hours in my best years trying to find out. Damn it.</p>&mdash; Gary Bernhardt (@garybernhardt) <a href="https://twitter.com/garybernhardt/statuses/482297459683495937">June 26, 2014</a></blockquote>

## Ruby applications are technical debt magnets

I've been writing Ruby full-time now for almost three years.  The majority of my job consists of maintaining about a dozen legacy Rails 2 / Ruby 1.8.7 applications, written between 2008-2010, with essentially zero tests amongst them (when I started).  Even after adding failing tests for bug fixes and doing TDD as much as possible when adding new features, these applications are still by and large pretty hairy.  Having to worry about causing regressions when making minor changes is not fun.

I don't think I'm alone in my experience:

<blockquote class="twitter-tweet" lang="en"><p>Developer who inherited 5-year-old Rails codebase secretly hoping for company collapse</p>&mdash; Hacker News Onion (@HackerNewsOnion) <a href="https://twitter.com/HackerNewsOnion/statuses/476835980863733761">June 11, 2014</a></blockquote>

How does this happen, and more importantly how can we prevent this? Testing is supposed to give us the confidence to refactor, right?  So surely the solution must be to write more tests and/or follow TDD more closely?

As good as it feels to fire up `git blame` and shake my fist at the <span title="irresponsible bastards">people</span> who wrote the code I'm maintaining and their lack of tests, I've come to understand that it's not entirely their fault.  While more tests would have made my situation a lot more tolerable (and seriously, there's no excuse for *zero* tests) I'm not convinced that more testing is a cure-all to Ruby's woes.

## Testing is hard

Testing in Ruby requires a great deal of effort that doesn't seem to get acknowledged much.  If you try to learn about Ruby / object-oriented testing - before you even write a line of code - you quickly get thrown into the deep end of the pool.  There's mocks, stubs, doubles, fakes, spies - all kinds of abstractions to use and knowledge to soak up.  There's really a whole industry built up around object-oriented testing, and some people make entire careers on evangelizing this stuff.

After theory complexity comes implementation complexity.  Although I prefer RSpec, others use Test::Unit or MiniTest, so I need to be knowledgable in those syntaxes as well if I want to be able to move between projects (and that's just unit testing frameworks).  And you are always subject to fads - currently there is a lot of noise about using fixtures instead of factories (e.g. FactoryGirl).  But even amongst usage of the same library there are often differences - there are [websites dedicated to best practices][better-specs], and just between versions there can be big differences (e.g. RSpec is moving from the `should` syntax to `expect`).

Basically what I'm getting at is that Ruby testing requires both a big upfront and continuing mental investment, the knowledge is not very portable, and the test code is subject to just as much bit rot as the rest of your code.  The anxiety from this burden often ends up causing developers to just not write tests, which can then be used as guilt to shame them:

<blockquote lang="en"><p>Test-first fundamentalism is like abstinence-only sex ed: An unrealistic, ineffective morality campaign for self-loathing and shaming.</p>— David Heinemeier Hansson (DHH) <a href="http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html">TDD is dead. Long live testing</a></blockquote>

It's simply unrealistic to rely on developers to always shoulder the burden of controlling Ruby's dynamic typing, silly putty flexibility with tests.  It's like having to rely on someone having to rebuild the guard every time they take out the chainsaw.  At some point, for whatever reason (e.g. the boss needs this done yesterday, or this is a production emergency, or it's just a script, etc.), you are going to just say fuck it and use the thing without the guard and take the risk of losing fingers. Of course the problem with the analogy applied to Ruby code is that you are also forcing everyone else who uses your code after you to take that same risk, and over time that risk gets larger.

## Tests are necessary, but insufficient

<blockquote lang="en"><p>Program testing can be used to show the presence of bugs, but never to show their absence!</p>— Edsger Dijkstra <a href="http://www.cs.utexas.edu/users/EWD/ewd02xx/EWD249.PDF">EWD249 "Notes On Structured Programming"</a></blockquote>

Sadly, even if you were to attain OO TDD guru status, ascend to your planar form, and achieve perfect code coverage with well-written tests all the time, your knowledge won't save you:

<blockquote class="twitter-tweet" lang="en"><p>Ruby: where requiring a module that ships with the stdlib changes how integer division works everywhere. <a href="http://t.co/pa2rgfNytH">pic.twitter.com/pa2rgfNytH</a></p>&mdash; Tom Dale (@tomdale) <a href="https://twitter.com/tomdale/statuses/457282269342744576">April 18, 2014</a></blockquote>

Even an OO TDD Buddha can't write tests that cover every permutation of side effects that are capable of altering your code like this.  It's hard to reason about code when it does something entirely different depending on what code has executed in the runtime before it.  Having to look at code sitting at rest and making a *best guess* as to what it will do when ran scares the shit out of me.

At some point we have to realize the madness of trying to patch a solid foundation over this using tests.  I mean, would you be comfortable if your bank relied on software that behaved like this?  If not, then why are you even using it for anything else - isn't your business logic just as critical to get right?

What we really need are more explicit guarantees on every line of code that we write (and more importantly, what we import from other crazy bastards) than what Ruby can provide.  We need guards that can't be removed, and code that simply doesn't compile when not structured correctly.

<blockquote class="twitter-tweet" lang="en"><p>“You’re having a beer at lunch?”&#10;“It’s okay, I work in a type-safe language.”</p>&mdash; Bill Couch (@couch) <a href="https://twitter.com/couch/statuses/480080763132465152">June 20, 2014</a></blockquote>

## The most maintainable Ruby code hints at the right path

The cleanest Ruby applications I see tend to:

* break functionality into lots of small objects
* use immutabile objects as much as possible (e.g. using thin veneers over primitives or [adamantium][adamantium])
* separate business logic into collections of functions that act on said objects ([service objects][service-objects])
* minimize mutation and side effects to as few places as possible
* thoroughly document expected type arguments for object instantiation and method invocation with unit tests (mimickry of a static type system)

To me, this code starts displaying aspects of functional programming languages.

<blockquote class="twitter-tweet" lang="en"><p>As you remove mutation, OO disappears, which is exactly what I&#39;ve found over the last five years. (Assuming you don&#39;t use inheritance.)</p>&mdash; Gary Bernhardt (@garybernhardt) <a href="https://twitter.com/garybernhardt/statuses/482601796225863680">June 27, 2014</a></blockquote>

## Drinking that Haskell Kool-Aid

[![I'm drinking it]({{ site.url }}/images/haskell-kool-aid.png)]({{ site.url }}/images/haskell-kool-aid.png)

I've decided to start learning Haskell (using [Chris Allen's guide][bitemyapp-guide]), a language that I feel solves a lot of the problems I have with Ruby.  I say I'm drinking the Kool-Aid because I've just barely scratched the surface of it, and although I really like what I see so far, I haven't used it a lot in practice yet and I don't know enough math / category theory to appreciate it on a theoretical level.  But I've read enough from smart people writing about it that I'm sold. :-)

Some things I like about Haskell:

* No mutation - all data structures are immutable.
* No side effects - when calling someone's code one doesn't have to worry about [launching missiles][i-told-you-it-was-private].
* Pure functions and referential transparency - calling the same function with the same arguments always gives the same output, and (again) doesn't cause side effects.  Enables [equational reasoning][equational-reasoning].
* Statically typed - programs with type errors cannot even compile.  And the type system is powerful, and can infer types - no Java verbosity required.
* Easy concurrency and parallelism thanks to the aforementioned pure functions, lack of side effects, immutability.
* [Types are documentation][types-are-documentation] that the compiler checks.
* [If it compiles, it oftentimes just works][it-compiles-it-works]
* A [high amount of code reuse due to the basis in category theory][code-reuse]. This is a failed promise of OO in my opinion.

I think there is enough learning material out there, and motivated teachers like [Chris Allen (@bitemyapp)][chris-allen], that even an idiot / not-super-mathy person like myself can get into Haskell for serious work.  And Haskell has enough depth that the more time I invest with it and the math theory underpinning it (category theory), I will unlock new, mathematically-sound abstractions that I can use pretty directly (e.g. [lenses][lens], [arrows][arrow]).  Perhaps some day I'll even be like those math warlocks, and able to appreciate languages with even more powerful type systems, e.g. ones with [dependent types][dependent-types] like [Idris][idris], [Agda][agda], or [Coq][coq] (one can dream).  Basically, Haskell's not a language that I anticipate getting bored of very quickly.

[![But Abe, you're terrible at math]({{ site.url }}/images/mathematical.gif)]({{ site.url }}/images/mathematical.gif)

## There is no silver bullet, and Ruby is not a werewolf

I'm not under the impression that Haskell is a perfect language (or that one exists).  And although I've seemingly whined a lot about writing tests, Haskell doesn't obviate the need for them - it just cuts down on a lot of unnecessary ones that you have to write in dynamically typed languages like Ruby.  Just want to make that clear for people who have rolled their eyes at me in the past when I've talked about this.

I'm also not saying Ruby is dead or dying; I don't see it going anywhere anytime soon.  Ruby has a very readable syntax, a language design that is easy to master, and tons of gems out there for doing all sorts of things.  I expect it to pull in a lot of new programmers for some time to come, for better or worse.  But most importantly, it's going to continue paying my bills for the foreseeable future. :-)

But for myself, it's hard to enjoy using Ruby nowadays when I've found something so much [further up on the power continuum][beating-the-averages].


[avdi-ruby-demise]:          http://devblog.avdi.org/2014/02/23/rumors-of-rubys-demise/
[dhh-tdd-dead]:              http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html
[SRP]:                       http://en.wikipedia.org/wiki/Single_responsibility_principle
[SOLID]:                     http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)
[law-of-demeter]:            http://en.wikipedia.org/wiki/Law_of_Demeter
[better-specs]:              http://betterspecs.org
[adamantium]:                https://github.com/dkubb/adamantium
[service-objects]:           http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
[code-reuse]:                http://www.haskellforall.com/2011/12/haskell-for-mainstream-programmers-code.html
[it-compiles-it-works]:      http://www.haskell.org/haskellwiki/Why_Haskell_just_works
[chris-allen]:               https://twitter.com/bitemyapp
[lens]:                      http://www.haskellforall.com/2012/01/haskell-for-mainstream-programmers_28.html
[arrow]:                     http://www.haskell.org/haskellwiki/Arrow
[i-told-you-it-was-private]: https://github.com/fxn/i-told-you-it-was-private/blob/b162d83aeadfdbb417791c7b7207ee2a13c67d90/lib/i-told-you-it-was-private.rb#L8
[bitemyapp-guide]:           https://github.com/bitemyapp/learnhaskell
[equational-reasoning]:      http://www.haskellforall.com/2013/12/equational-reasoning.html
[types-are-documentation]:   https://dl.dropboxusercontent.com/u/7810909/media/doc/parametricity.pdf
[dependent-types]:           http://en.wikipedia.org/wiki/Dependent_type
[idris]:                     http://en.wikipedia.org/wiki/Idris_(programming_language)
[agda]:                      http://en.wikipedia.org/wiki/Agda_(programming_language)
[coq]:                       http://en.wikipedia.org/wiki/Coq
[beating-the-averages]:      http://www.paulgraham.com/avg.html
