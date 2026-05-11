#import "lib.typ": *
#let version = toml("typst.toml").package.version

#book(root: "otter-docs", tree: (
  chapter("index", content: include "doc/intro.typ"),
  chapter("doc/installing"),
))
