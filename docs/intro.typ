#title[Introduction]

#let version = toml("../typst.toml").package.version

Welcome to the documentation for Otter Docs #version.

Typst is good at generating PDFs. It also has experimental support for HTML files. Since \#7964 Typst can export
multiple files for a single project, which makes it ideal for stuff like documentation sites.

Otter Docs uses the bundle target. You can make a new project in Typst, set it to bundle export, and it would generate a
site for you. It's only a typst template, and you don't need to worry about setting up the toolchain – because Typst is
the only tool required.

Otter Docs is not a serious tool, and currently it still lacks a lot of other stuff such as SEO and html minifications,
but it is a starting point.

= Contexual Output

#context if target() == "html" [
  You are currently looking at the HTML target. The default theme is inspired by Documenter.jl's "Documenter" theme,
  which is based on sphinx's sphinx_theme_std. You can also take a look at the #link(<doc.pdf>)[PDF document].
] else [
  You are currently looking at the PDF target.
]

= Installation

Just fetch it from the Typst universe.

= Building the Documentation

You would need a version of Typst that supports the bundle target.

= Customization

You can customize the rendering process by writing your own renderer.

= Comparisons

== Compared with mdBook:

Pros:
- Pure Typst
- Easy setup. You only need to download the template once and Typst would handle everything else for you.
- Easy PDF generation

Cons:
- Pure Typst, and Typst is harder than Markdown
- mdBook has better documentation

== Compared with Shiroa:

Pros:
- Easy setup; doesn't require a standalone CLI program.

Cons:
- Lacks SEO and other html-specific optimizations.
