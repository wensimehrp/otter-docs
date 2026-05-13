#title[Tutorial]

= Setups

If you've used a tool like #link("https://myriad-dreamin.github.io/shiroa/")[Shiroa], you might be familiar with the
`book.typ` file. The `book.typ` file contains all sorts of metadata related with the book, similar to `summary.md` in an
mdBook project.

In Otter Docs, all of that is concentrated to a single entrypoint -- the `book` function:

```typ
#book(
  // The routing root. Useful when you are deploying
  // to a subfolder
  root: "otter-docs",
  // Your document's contents
  tree: (
    // otter-docs/index.html
    chapter("index", content: include "doc/intro.typ"),
    // otter-docs/doc/tutorial.html
    chapter("doc/tutorial"),
    // you can add more chapters here.
  )
)
```

You can then compile using the following arguments. Remember to replace `<input-file>` with your actual filename

```console
$ typst c --features bundle,html <input-file> -f bundle ./dist
```

This would create the documentation in the `./dist` folder.
