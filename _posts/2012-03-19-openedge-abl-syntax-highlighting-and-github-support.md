---
title: "OpenEdge ABL syntax highlighting and GitHub support"
date: 2012-03-19 18:57
header:
  og_image: openedge-abl-syntax-highlighting-and-github-support/octocat.png
---

[{% asset "openedge-abl-syntax-highlighting-and-github-support/octocat.png" alt="GitHub Octocat logo" %}](https://github.com/languages/OpenEdge ABL)

As I had written in my last blog post, in order to upgrade my blog
from Wordpress to a static site like Octopress, I decided that while performing
the migration I would improve the syntax highlighting of OpenEdge ABL code
snippets.  Obviously I'm [no fan][0] of the language, but it's baggage that I'm
burdened to carry so I thought I might as well carry it with me in style.

Being an esoteric and proprietary language, ABL doesn't have much mainstream
support for things like syntax highlighting.  When my blog was using Wordpress,
I had to [add support][1] myself to the de-facto Wordpress syntax highlighting
library, Alex Gorbachev's [SyntaxHighlighter][2].  I never really liked it
though, as SyntaxHighlighter is a JavaScript library and its modus operandi
is to make the client browser perform the syntax highlighting when the page
is loaded.  This means if the page is a little slow to load, the code would
not be highlighted immediately.  Also, due to ABL's criminal overuse of
keywords, the syntax highlighting code was massive, weighing in around 31.5KiB
even after being minified!

## Pygments lexer
Syntax highlighting is really something that should be done at compile-time,
so I was keen to get rid of the JavaScript solution.  [Octopress][3], which is
what I currently use for blogging, uses a Python library called [Pygments][4]
for syntax highlighting.  Pygments is basically the *defacto library* for
syntax highlighting.  It supports a [huge number][5] of languages, supports
a wide array of output formats, including HTML, ANSI (console), LaTeX, and RTF,
and the [lexer base classes][6] it comes with allow one to write the lexer in
the most flexible manner, including even mixing different lexer types
together (the most common being regex with a simple stack, necessary for
handling state such as for nested comments)!

Therefore, I had to write an OpenEdge lexer myself for Pygments.  This lexer
has since been included in the recent [Pygments 1.5][7] release, so is
available for download and use right now.

## GitHub support
I was happy to learn that GitHub's syntax highlighting is also done using
Pygments.  They use a custom gem called [linguist][8] for this purpose.
Linguist itself uses another gem called [pygments.rb][9] for calling
out to Pygments by using the [RubyPython][10] library, which actually embeds
a Python interpreter inside of Ruby using FFI (very cool, and also fast!).

I went ahead and wrote the [linguist support][11] for OpenEdge, the
[update to pygments.rb][12] to update its Pygments version, and also helped
out a bit on the linguist issues list by adding [Coq lexer support][13]
([requested by someone][14]), [improving the PowerShell lexer][15], and
[guiding][16] some others through the process of adding support for their
language (making sure all the tests pass, etc.) and
[answering][17] misc. questions.

As a result, OpenEdge ABL is now on GitHub's [language list][18], and it is now
possible to write [gists][19] in ABL with syntax highlighting.  Pretty hip
for such an old and crappy language.

It was very cool to go through the process of writing some code that will
actually be running on GitHub's core infrastructure, even though it's just a
little piece. :-)  It also feels nice to write open source software.  I hope
that when my wife finally finishes medical school and becomes a doctor and
after my daughter grows a bit older that I will have more time to contribute
to it.


[0]: http://blog.abevoelker.com/progress_openedge_abl_considered_harmful/
[1]: https://github.com/abevoelker/SyntaxHighlighter-Progress-OpenEdge-ABL-Brush
[2]: http://alexgorbatchev.com/SyntaxHighlighter/
[3]: http://octopress.org/
[4]: http://pygments.org/
[5]: http://pygments.org/languages/
[6]: http://pygments.org/docs/lexerdevelopment/
[7]: http://pygments.org/docs/changelog/#version-1-5
[8]: https://github.com/github/linguist
[9]: https://github.com/tmm1/pygments.rb
[10]: https://bitbucket.org/raineszm/rubypython
[11]: https://github.com/github/linguist/pull/115
[12]: https://github.com/tmm1/pygments.rb/pull/12
[13]: https://github.com/github/linguist/pull/125
[14]: https://github.com/github/linguist/issues/116
[15]: https://github.com/abevoelker/linguist/tree/detect-powershell
[16]: https://github.com/github/linguist/pull/112
[17]: https://github.com/github/linguist/issues/134
[18]: https://github.com/languages/OpenEdge%20ABL
[19]: https://gist.github.com/
