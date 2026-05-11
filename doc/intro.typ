Welcome to the documentation for Otter Docs version.

= Introduction

Typst is good at generating PDFs. It also has experimental support for HTML files. Since \#7964 Typst can export
multiple files for a single project, which makes it ideal for stuff like documentation sites.

Otter Docs uses the bundle target. You can make a new project in Typst, set it to bundle export, and it would generate a
site for you. It’s only a typst template, and you don’t need to worry about setting up the toolchain – because Typst is
the only tool required.

Otter Docs is not a serious tool, and currently it still lacks a lot of other stuff such as SEO and html minifications,
but it is a starting point.

= Contexual Output

You are currently looking at the HTML target. The default theme is inspired by Documenter.jl’s “Documenter” theme, which
is based on sphinx’s sphinx_theme_std.

= Installation

Just fetch it from the Typst universe.

= Building the Documentation

You would need a version of Typst that supports the bundle target.

= Customization

You can customize the rendering process by writing your own renderer.
