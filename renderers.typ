#let paged-renderer(c, ..args) = {
  // c
}

// Documents are separated by pages.
#let prose-classes = {
  for (level, font-size) in (
    h1: "text-3xl",
    h2: "text-2xl",
    h3: "text-xl",
  ) {
    let selector = "[&>" + level + "]:"
    ("font-bold", "mt-8", font-size).map(it => selector + it)
  }
  ("[&>p]:mt-4",)
}

#let heading-body-to-id(h) = {
  let t = h.body.fields().text
  lower(t).replace(regex("\s+"), "-")
}

#let summary-renderer(current-tree, page-path) = for it in current-tree {
  import html: *
  div(
    class: "w-full relative",
    if it.kind == "chapter" {
      a(
        href: "/" + it.path.join("/") + ".html",
        class: "block py-1 px-2 min-h-8 relative "
          + if it.path == page-path {
            "bg-blue-100"
          } else {
            "hover:bg-neutral-200"
          },
        it.kind,
      )
      if it.children.len() > 0 {
        input(
          class: "absolute peer top-2 right-2 h-4 w-4",
          type: "checkbox",
          checked: true,
        )
      }
    } else {
      div(class: "p-2", it.content)
    }
      + if it.children.len() > 0 {
        div(
          class: "ml-3 border-neutral-300 border-l border-b col-start-2 col-span-2 hidden peer-checked:block",
          summary-renderer(it.children, page-path),
        )
      },
  )
}

#let flatten-tree(tree) = {
  let out = ()
  for it in tree {
    let base = it
    let _ = base.remove("children")
    out.push(base)
    out += flatten-tree(it.children)
  }
  out
}

#let footer-renderer(final-tree, current) = html.footer(class: "mt-4 py-8 grid grid-cols-[1fr_1fr] gap-4", {
  let flattened = flatten-tree(final-tree)
  let current-idx = flattened.position(it => it.path == current.path)
  let link-classes = " border-1 border-neutral-300 p-4 hover:bg-neutral-100 hover:shadow-xs "
  if current-idx == none {
    return
  }
  if current-idx > 0 {
    let info = flattened.at(current-idx - 1)
    html.a(class: "col-start-1" + link-classes, href: "/" + info.path.join("/") + ".html", "« " + info.kind)
  }
  if current-idx < flattened.len() - 1 {
    let info = flattened.at(current-idx + 1)
    html.a(class: "col-start-2 text-right" + link-classes, href: "/" + info.path.join("/") + ".html", info.kind + " »")
  }
  html.p(class: "col-span-2 text-xs text-center")[
    Powered by #html.a(href: "https://github.com/wensimehrp/otter-docs")[Otter Docs]. Made in Vancouver with love.
  ]
})

#let internal-html-renderer(final-tree, it, path) = document(path, html.div({
  import "@local/typhoon:0.1.0": *
  import html: *
  show: tailwind-page

  input(class: "z-10 fixed peer md:hidden top-4 left-4 checked:translate-x-72 transition-transform", type: "checkbox")
  nav(
    class: "w-72 z-10 flex fixed left-0 top-0 h-full -translate-x-full shadow-sm md:shadow-none peer-checked:translate-x-0 md:translate-x-0 flex-col border-r border-neutral-300 bg-neutral-100 transition-transform",
    {
      img(
        class: "max-h-40 mx-auto my-5",
        src: "https://upload.wikimedia.org/wikipedia/commons/3/36/WLE_Austria_Logo_%28transparent%29.svg",
      )
      div(
        class: "border-t border-neutral-300 overflow-x-auto",
        {
          summary-renderer(final-tree, it.path)
        },
      )
    },
  )
  div(class: "p-8 max-w-4xl md:ml-72 " + prose-classes.join(" "), {
    header()[Something Documentation]
    it.content
    footer-renderer(final-tree, it)
  })
}))

#let recursive-html-renderer(final-tree, current-tree) = {
  for it in current-tree {
    if it.kind == "chapter" [
      #let path = "/" + it.path.join("/") + ".html"
      #internal-html-renderer(
        final-tree,
        it,
        path,
      ) #label("page:" + path)
    ]
    recursive-html-renderer(final-tree, it.children)
  }
}

#let html-renderer(tree, ..args) = {
  recursive-html-renderer(tree, tree)
}
