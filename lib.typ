#let chapter(
  path,
  content: auto,
  children: (),
  ..args,
) = {
  let path = if type(path) == array { path } else { path.split("/").filter(it => it.len() > 0) }
  (
    kind: "chapter",
    path: path,
    content: if content == auto {
      include path.join("/") + ".typ"
    } else {
      content
    },
    children: children,
    ..args.named(),
  )
}

// https://github.com/typst/typst/issues/2196#issuecomment-1728135476
#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}

#let normalize-tree(tree, root) = {
  let new-tree = ()
  for it in tree {
    if type(it) != dictionary or "kind" not in it {
      it = (
        kind: "other",
        content: it,
      )
    }
    if "path" in it {
      it.path = root + it.path
      it.insert("page-label", label("page:/" + it.path.join("/")))
    }
    if it.kind == "chapter" {
      // The correct practise is to use label here; however we couldn't use that because of
      // https://github.com/typst/typst/issues/2926
      // So we manually construct (heading, href) pairs instead
      let chapter-heading-state = state(it.path.join("/") + " chapter state", ())
      let chapter-title-state = state(it.path.join("/") + " title state", none)
      it.content = {
        show heading.where(level: 1, outlined: true): h => {
          let key = lower(to-string(h).replace(" ", "-"))
          chapter-heading-state.update(arr => (
            arr
              + (
                (h, "/" + it.path.join("/") + ".html#" + key),
              )
          ))
          if target() == "html" {
            html.h2(id: key, h.body)
          } else {
            h.body
          }
        }
        show title: title => {
          chapter-title-state.update(it => title.body)
          title
        }
        it.content
      }
      it.insert("title", chapter-title-state.final())
      it.insert("headings", chapter-heading-state.final().dedup())
    }
    if "children" in it {
      it = (..it, children: normalize-tree(it.children, root))
    }
    new-tree.push(it)
  }
  new-tree
}

#import "renderers.typ": html-renderer, paged-renderer

#let book(
  title: "",
  description: "",
  authors: (),
  root: (),
  language: "en",
  html-renderer: html-renderer,
  paged-renderer: paged-renderer,
  debug: false,
  tree: (),
  ..args,
) = context {
  let root = if type(root) == array { root } else { root.split("/").filter(it => it.len() > 0) }
  assert(type(authors) == array, message: "Authors must be an array of strings.")
  let normalized = normalize-tree(tree, root)
  // debug for testing the tree
  if debug { document(root.join("/") + "/__debug_tree.html", [#normalized]) }
  if target() in ("bundle", "paged") {
    paged-renderer(
      normalized,
      description: description,
      authors: authors,
      root: root,
      language: language,
      ..args,
    )
  }
  if target() in ("bundle",) {
    html-renderer(
      normalized,
      description: description,
      authors: authors,
      root: root,
      language: language,
      ..args,
    )
  }
}
