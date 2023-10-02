Unicode
=======

[https://tonsky.me/blog/unicode/](https://tonsky.me/blog/unicode/)

The Unicode __standard__ is an attempt to model all human writing systems and work with computers.

In practice the standard is just a giant table that assigns unique numbers to different characters. This numbers are also called __code points__.

* The letter `A` is assinged `65`.
* The katakana letter `ツ` is `12484`
* `💩` is `128169`

And so on.

Currently this giant table has space for about 11 million code points, but only ~170k are currently defined. So there's plenty of space left!

By convention code point values are written as `U+<hexadecimal value>`. The `U+` prefix just indicates that this is a Unicode value. So `💩`'s code point is written as U+1F4A9.

So what's UTF-8 then?
---------------------

Unicode is just a standard – it's the interface, but not the implementation. UTF-8 is an __encoding__ that defines how to store code points in memory. UTF-32 and UTF-16 are also encodings, but UTF-8 is the dominant Unicode encoding.

UTF-8 is a _variable length encoding_, meaning that the size of each code point encoding can vary, in this case between one and four bytes. 

In practice most Latin alphabet characters are encoded with one byte; Cyrillic, Arabic, and Hebrew need two; East asian character sets need 4. This variable length encoding makes UTF-8 space-efficient for basic Latin characters, but it takes up more space for other writing systems.

Importantly, UTF-8 is byte-compatible with the old ASCII encoding. Code points 0..127 overlap with the ASCII encodings exactly.

Grapheme clusters
-----------------

We've elided over some details so far. _Usually_, you can assume that a single codepoint corresponds with a single character. However, this often osm
t the case. Some characters are actually made up of _multiple codepoints added together_.

For example, 

* `é` is encoded as `e` plus `´` (`U+0065` + `U+0301`)
* `☹`️ is `U+2639` + `U+FE0F`

In Unicode, we call characters a human would recognize as single characters __graphemes__. Single characters that are built using multiple code points are called __extended grapheme clusters__.

A living standard
-----------------

The Unicode standard has been releasing a major revision every year since 2014. This is where you get all your new emojis from.

The sad reality for programmers is that these updates often _change the codepoint combinations_ for extended grapheme clusters. Why they do this, no one knows.
