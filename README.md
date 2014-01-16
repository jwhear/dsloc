dsloc
-----
A source-lines-of-code (SLOC) counter for the D language, written in D.
Author: Justin Whear

This program employs a few simple regexes on a per-line basis to count the number of blank (whitespace only), comment, and code lines in a D file.

```
Usage: dsloc <somefile.d
       dsloc a.d b.d c.d
       find . -name '*.d' | xargs dsloc
```

Methodology
-----------
If a line is not blank, not a line comment, and not in a comment block, then it is a source line.

The simple matching technique is not foolproof--it is possible to construct comment blocks which will fool the parser.  E.g. mixing `/*` and `+/`
