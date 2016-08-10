---
layout: post
title: "menosgrande - My First Ruby on Rails App!"
date: 2011-06-20
comments: true
facebook:
  image: menosgrande.png
excerpt_separator: <!--more-->
permalink: menosgrande_my_first_rails_app/
---

[Unicode]: http://unicode.org/standard/WhatIsUnicode.html

[![](/images/menosgrande.png)](http://menosgrande.org)

I'm proud to announce the release of my first Ruby on Rails app -
[menosgrande](http://menosgrande.org)!

It's not a very complicated application; it's just a URL shortener.  However,
I've tried to make it the most efficient URL shortener in existence by doing
a few things uniquely that I don't see any other URL shorteners doing:

<!--more-->

* **[Unicode][] paths** (i.e. [IRI](http://tools.ietf.org/html/rfc3987)s).
  While other URL shortening services use the digits [a-zA-Z0-9] only as keys,
  resulting in 62 unique characters, menosgrande uses over 107,000 unique
  Unicode code points. By using so many code points, menosgrande can store
  over twelve times the number of URLs in two Unicode digits than other
  services using five base-62 digits
  [compare 107000^2 to 62^5](http://www.google.com/search?q=107000^2%2F62^5)
  to see the difference).
* **Short domains**. Some services use long domain names,
  which waste characters from the start (e.g. goo.gl, tinyurl.com, etc.).
  menosgrande uses the shortest combination of characters possible: a two-digit
  TLD and a single-digit subdomain, resulting in a base URL that is already
  extremely short.  Currently, the only way you can theoretically get a shorter
  DNS address than this is by doing insanity like using a root ccTLD like the
  <a href="http://news.ycombinator.com/item?id=974111">.to ccTLD</a> used to do
  (which it no longer does).
* **Multiple domains**. menosgrande doesn't attempt to use a single unique
  domain name for short links. Instead, it keeps a pool of domains for that
  purpose. Each domain in this pool multiplies the number of URLs that
  menosgrande can shorten.

Caveat: the Unicode trick only works if the service reading the shortened URL
counts Unicode code points as single characters, and not raw bytes.  Obviously,
this is exactly [how Twitter counts characters](http://dev.twitter.com/pages/counting_characters),
or I wouldn't have done this.  Just wanted to
point that out before you make a fool out of yourself with a
[loud-mouthed, incorrect statement](http://stackoverflow.com/questions/6246651/generate-uri-friendly-unicode-code-points-from-integer-counter/6246651/#comment-7441733).

The hardest piece of the puzzle to solve was which Unicode code points to use
as keys, because Unicode doesn't simply encode simple alphabetical characters
like the Latin alphabet.  There are lots of formatting characters, whitespace
characters, private use characters (for internal Unicode parser usage), control
code characters (e.g. NUL), and lots of others that would not work for my URL
shortener.  Unicode is such a dry read, it took me a while to understand all of
the code points that need to be filtered out.  I eventually came up with a
decent list:

*  Noncharacters
*  Control codes
*  High/Low surrogates
*  Private-Use
*  Formatting, Bidirectional
*  Combining characters / diacritical marks
*  Whitespace

Then, it became quite a struggle to actually figure out how to apply this
filter to the full set of Unicode code points.  I tried the Perl <code><a
href="http://98.245.82.12/tcpc/scripts/unichars">unichars</a></code> utility,
which I believe has the capability to do what I need, but my version of Perl
(5.10.1) is linked to a Unicode 5.x standard; I couldn't quickly find any
instructions for upgrading to the Unicode 6.0.0 standard. I had considered
writing a Ruby app similar to <code>unichars</code>, but my Ruby install is
also on a Unicode 5.2 standard (Ruby 1.9.2, ActiveSupport 3.0.8). I found
[a way](http://rubydoc.info/gems/activesupport/3.0.8/ActiveSupport/Multibyte/Unicode/UnicodeDatabase#load-instance_method)
to apparently load a different Unicode table, but there is no
documentation for it and the unicode_tables.dat file on my system is a binary
file so no easy answer there.

I had also considered parsing the Unicode 6.0.0 standard's <a
href="http://www.unicode.org/Public/6.0.0/ucd/UnicodeData.txt">UnicodeData.txt</a>
file myself, but apparently there are ranges of code points missing, such as
Han, which would require me parsing yet another file in <a
href="http://www.unicode.org/reports/tr38/">its own format</a>.

In the end, I stumbled across an official <a
href="http://unicode.org/cldr/utility/properties.html">Unicode Properties</a>
JSP Web app that had the capability I needed, with full Unicode 6.0.0 support.
Here is the filter that I used to select my code points:

```
[:Diacritic=No:]&[:Noncharacter_Code_Point=No:]&[:Deprecated=No:]&[:White_Space=No:]&[:General_Category=Math_Symbol:]|[:General_Category=Symbol:]|[:General_Category=Letter:]|[:General_Category=Punctuation:]|[:General_Category=Currency_Symbol:]|[:General_Category=Number:]&[:General_Category!=Modifier_Letter:]&[:General_Category!=Modifier_Symbol:]
```

which yielded 107,401 code points.  I then had to filter out
[URI-scheme reserved characters](http://tools.ietf.org/html/rfc3986#section-2.2)
- and a few other characters that just make me paranoid - and I
was still well over 107K code points.  I then shuffled the order of the code
points (seeding the PRNG with a constant value beforehand, to make the shuffle
repeatable) and stored them in a <a
href="http://redis.io/topics/data-types">Redis list</a>, to keep them in main
memory for fast access.  I make use of a Ruby <a
href="http://rubyworks.github.com/radix/">radix gem</a> to convert my integer
counter values into the Unicode code point values.  So far, it appears to be
working very well!

I know it isn't the most complicated piece of software ever written, but it was
a fun project and a good one for helping me learn Rails.  I'm hoping it will
also raise some <a
href="http://www.joelonsoftware.com/articles/Unicode.html">basic awareness</a>
of Unicode in the process!

I'm not sure yet whether I'll continue to work on features like an API, or just
open source it and move on to another Rails project. Sometimes it's hard to
keep working on details once the interesting problem has been solved. I think
it will depend on how soon I get a Rails job here in Madison.

Anyone want to hire me yet? :-)
