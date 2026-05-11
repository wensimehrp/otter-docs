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
      it = (..it, path: root + it.path)
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
  tree: (),
  ..args,
) = context {
  let root = if type(root) == array { root } else { root.split("/").filter(it => it.len() > 0) }
  assert(type(authors) == array, message: "Authors must be an array of strings.")
  let normalized = normalize-tree(tree, root)
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
