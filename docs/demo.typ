#title[Demo]

= Typography

Tailwind Typography and Typst helps styling `inline code`, coloured inline code:
```rust fn foo<T: Clone>(f: fn(T) -> ())```, *bold*, _italics_, *_bold italics_*, #highlight[highlighted text],
#underline[underlined text], #overline[overlined text], "quoted text", "quote's 'effect' in quoted text",
#smallcaps[SmallCaps], #strike[strikethrough text], #sub[subscripts], #super[superscripts], #upper[uppercase text],
#highlight(underline(
  overline[*And* a #sub(
      smallcaps(strike["_comprehensive_"]),
    ) #super(upper[*_example_*])],
))

#lorem(100)

#for i in range(4) {
  heading(level: i + 1, [Heading #(i + 1)], outlined: false)
}

Note that these headings are not outlined, so they would not appear on the sidebar.

Framed text:

#html.frame[#lorem(10)]

= Math

Inline: the root formula is $x = (-b plus.minus sqrt(b^2 - 4 a c))/(2a)$ and the Chudnovsky algorithm is
$1/pi = sqrt(10005)/4270934400 sum^oo_(k=0) ((-1)^k(6k)!(545140134k + 13591409))/((3k)!(k!)^3(640320)^(3k))$ with
#lorem(30)

#link(
  "https://en.wikipedia.org/wiki/Chudnovsky_algorithm",
  figure(
    caption: [Click on the formula!],
    $
      1/pi = sqrt(10005)/4270934400 sum^oo_(k=0) ((-1)^k(6k)!(545140134k + 13591409))/((3k)!(k!)^3(640320)^(3k))
    $,
  ),
)

= Lists

Unordered list:

- Foo
- Bar
- Baz
  - Fizz
  - Buzz

Numbered list:

+ Foo
+ Bar
+ Baz
  + Fizz
  + Buzz

= Table


= Code

The source code of this example:

#raw(block: true, lang: "typ", read("./demo.typ"))
