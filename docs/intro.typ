#title[Introduction]

#let version = toml("../typst.toml").package.version

Welcome to the documentation for Haita #version (hǎi tǎ, Mandarin Pinyin, lit. Sea Otter).

Writing documentation is a lame task. It is even more boring and frustrating when you have to setup toolchains and
environments and debug for hours to make sure that they build correctly, only to find that the current tools cannot plot
your diagrams, or the PDF generation is missing fonts and takes hours to build. So here's Haita. A simple tool that has
a single requirement: #link("https://github.com/typst/typst")[Typst]. Here are some features:

- Pure Typst workflow
- Features inherited from Typst:
  - Simple yet expressive Typst syntax helping you focussing on your content
  - Native syntax highlighting
  - Native MathML output
  - Fast compliation
  - Native support for `watch` and `serve`
  - PDF and HTML generation from the same source #footnote[
      PDF generation is currently suspended. See #link("https://github.com/typst/typst/issues/8309") for details.
    ]
  - HTML minification.
- Minimal client side JS by default (for copying code). No JS required for math blocks. Site fully usable and
  navigatable without JS.
- Good SEO, including generating preview images for links.
- Semantic output, and
- Minimal setup

#import "@preview/merman:0.1.0": mermaid

#figure(caption: [How Haita Works], mermaid(
  ```mermaid
  flowchart LR
  Typst --> Haita
  Mermaid --> Haita
  Markdown --> Haita
  D[...] --> Haita
  Haita --> HTML
  Haita --> PDF
  ```.text,
))

#figure(
  caption: [A math formula example (#link(
      "https://tex.stackexchange.com/questions/176443/large-equation-goes-out-of-margin-want-to-centre-it",
    )[source])],
  $
    italic(W) = (Psi'^2 a b)/(2 mu_0) [
      mu^2 + sum_(m,n) ((a^2_(m n))/4 ((m^2 n^2)/a^2 + (n^2 pi^2)/b^2 + mu^2) + (8 a_(m n) mu^2)/(pi^2 m n) )
    ]
  $,
)

The default theme, _New Hamber_, also supports dark mode.

You can make a new project in Typst using Haita, set it to #link("https://github.com/typst/typst/pull/7964")[bundle
  export], and Haita would generate a site for you. You don't need to worry about setting up the toolchain – Typst is
the only tool required.

= An Unfinished Project

Haita is a decent choice for organizing long, comprehensive documentation. But just like Typst, Haita is an unfinished
project, and is (currently) not a serious tool. Specifically, it's missing these features:

- Internationalization support
- Built-in search functions (#link(<pagefind-integration>)[pagefind integration] available)

However, if you want pure Typst documentation, ease of use, and/or MathML formulae, you might want to give it a try. If
you want stability and extremely easy syntax, then maybe you should consider mdBook. If you have any issues, please feel
free to #link("https://github.com/wensimehrp/haita/issues")[open a ticket on GitHub]. If you would like to contribute,
please #link("https://github.com/wensimehrp/haita/pulls")[open a pull request].

= Licensing

The source and the documentation are available under #link("https://www.apache.org/licenses/LICENSE-2.0")[Apache License
  v2.0].

= Tracking

This site uses #link("https://umami.is/")[Umami] to track visitor status. It stores no cookies and does not collect
personal data. All data collected are anonymous, and you can disable tracking for this site following #link(
  "https://docs.umami.is/docs/exclude-my-own-visits",
)[this guide].
