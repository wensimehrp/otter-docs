#title[Tutorial]

Haita uses Typst. If you are not familiar with Typst, you can first take a look at #link(
  "https://typst.app/docs/tutorial",
)[Typst's official tutorial] for info on how to write Typst.

= Writing Your First Document

If you've used a tool like #link("https://myriad-dreamin.github.io/shiroa/")[Shiroa] or #link(
  "https://rust-lang.github.io/mdBook/",
)[mdBook], you might be familiar with `book.typ` or `summary.md`. Both files contain metadata and instructions on how to
organize the book. In Haita, all of that is concentrated to a single entrypoint -- the `book` function. To get started,
create a file named `dist.typ` that contains the following:

#let sample = (
  ```typ
  #import "@preview/haita:__PACKAGE_VERSION__": * // Always remember to import the package
  #book(
    // The routing root. Useful when you are deploying to a folder
    // under your root (e.g. when deployed to GitHub Pages)
    // root: "haita",
    // Your document's contents
    tree: (
      // You can add arbitrary content. The content will be displayed
      // in the summary, but will not generate html pages.
      [= Introduction],
      // This will create haita/index.html. The content of the
      // chapter will be from `doc/intro.typ`
      chapter("index", content: include "doc/intro.typ"),
      // This will create haita/doc/tutorial.html. In this case,
      // the content of the chapter is not explicitly stated, so it
      // looks into ./doc/tutorial.typ in the current workspace.
      chapter("doc/tutorial"),
      // You can add dividers, which will separate content in the summary.
      divider(),
      // you can also add arbitrary content
      [Made with Haita],
      // Alternatively, if you would like to directly include the content
      // without creating a new file, you can write it like this:
      chapter("my-page", content: [
        #title[My Page]
        = Heading 1
        = Heading 2
        foo bar baz
      ]),
      // you can add more chapters afterwards.
    )
  )
  ```
    .text
    .replace("__PACKAGE_VERSION__", toml("../typst.toml").package.version)
)

#raw(block: true, lang: "typ", sample)

Each chapter should start with a #link("https://typst.app/docs/reference/model/title/")[`title`]. The title of the page
will also be displayed in the summary. Do not start your document with a level 1 heading that looks like this:
```typst = Heading```. Instead, write this:

```typ
#title[My amazing document]

= Heading 1
Overseas from coast to coast

= Heading 2
To find a place I love the most
```

The rest of your document is just normal Typst content. You could apply show rules or use functions, just like writing a
normal Typst document.

== Developing (Typst Web App)

_The `typst.app` web app currently does not support the bundle target and MathML exports. This section will be completed
once the web app adds support for the bundle target._

== Developing (Local machine)

Open a terminal on your device. In the terminal, type the following command, then press `return`:

```sh
typst compile --features bundle,html --format bundle dist.typ
```

This will generate a folder `dist/` inside the same folder where you put your `dist.typ` file. The content inside
`dist/` is your document. You can see more available options by executing `typst help`.

The ```sh typst compile``` command only generates `dist/` once. Any subsequent edits will not appear inside `dist/`. Use
the following command to let Typst monitor your changes:

```sh
typst watch --features bundle,html --format bundle dist.typ
```

This will also generate a folder `dist/` alongside `dist.typ`, but this time there is some extra information:

```
watching ./dist.typ
writing to ./dist
serving at http://127.0.0.1:3000         <-- notice this line!

[HH:MM:SS] compiled with warnings in <some-time>

warning: bundle export is experimental
 = hint: its behaviour may change at any time
 = hint: do not rely on this feature for production use cases
```

This tells you that Typst is actively monitoring your files, and any changes you make to the files will let Typst
recompile the project. This line `serving at http://127.0.0.1:3000` (3000 might be a different number) tells you that
Typst has opened a local development server that this specific address. You can copy `http://127.0.0.1:3000`, open a
browser, and paste that line in the address bar.

You will see your document's index page in your browser.

```sh typst watch``` is very fast. This is because Typst uses #link(
  "https://github.com/typst/typst/blob/main/docs/dev/architecture.md",
)[incremental compilation] for recompilations.

= Architecture

The documentation system has two parts: the organizer, which is the #link(<haita-book>)[`book` function], and the
renderer.

The `book` function will organize the content into a tree, and that tree is then fed into the renderer. The renderer
will take a tree, inspect it, then generate pages based on that tree. This means that writing your own renderer is
trivial. You can swap to a different renderer at any time.
