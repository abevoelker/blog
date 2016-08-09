---
layout: post
title: "Progress / OpenEdge / ABL Syntax Highlighting for HTML & Wordpress"
date: 2010-07-08
comments: true
excerpt_separator: <!--more-->
permalink: openedge_abl_syntax_highlighter_javascript/
---

[GitHub]: http://github.com/abevoelker/SyntaxHighlighter-Progress-OpenEdge-ABL-Brush

Just finished polishing up and committing a Progress/OpenEdge/ABL syntax
highlighting brush extending Alex Gorbachev's JavaScript
[SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/) to [GitHub][]!

<!--more-->

I also took the liberty of integrating it with Wordpress by creating a plugin
extending Viper007Bond's
[SyntaxHighlighter Evolved](http://www.viper007bond.com/wordpress-plugins/syntaxhighlighter/)
plugin. Kudos to him for his
[easy-to-follow guide](http://www.viper007bond.com/wordpress-plugins/syntaxhighlighter/adding-a-new-brush-language/),
as I have zero experience with Wordpress plugins.

Here is the (weak, I know) code highlighting example I included in the
example.html file in my
[GitHub commit][GitHub]:

```abl
{include.i}

&SCOPED-DEFINE MY_NAME "Abe"

DEFINE VARIABLE iUnused AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE ttNames NO-UNDO
  FIELD cName AS CHAR
  INDEX IXPK_ttNames IS PRIMARY UNIQUE cName.

/* One-line comment */
/* Two-line
   Comment  */

CREATE ttNames.
ASSIGN ttNames.cName = {&MY_NAME}.

FOR EACH ttNames:
  MESSAGE "Hello, " + ttNames.cName + '!' VIEW-AS ALERT-BOX.
END.
```

Please let me know if you find it useful!  I figured this is the first step
to take in order to share some ABL code snippets on here. I will try and post
up some design patterns I've modelled using object-oriented ABL soon!
