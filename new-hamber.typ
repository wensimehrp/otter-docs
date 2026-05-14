// Default theme "New Hamber"

#let summary-renderer(current-tree, current-chapter) = for it in current-tree {
  html.div(
    class: "w-full relative"
      + if it.page-label == current-chapter.page-label {
        " bg-white border-y border-neutral-300 "
      } else {
        " hover:bg-neutral-200 "
      },
    if it.kind == "chapter" {
      html.div(
        class: "block w-full px-2 py-1".split(" ").map(it => "[&>a]:" + it).join(" "),
        std.link(it.page-label, it.title),
      )
      if it.page-label == current-chapter.page-label {
        html.div(
          class: " mx-2 border-t border-neutral-300 "
            + "px-2 py-1 block hover:bg-neutral-200".split(" ").map(it => "[&>a]:" + it).join(" "),
          for label in it.headings {
            std.link(label, query(label).at(0).body)
          },
        )
      }
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
      + if "children" in it and it.children.len() > 0 {
        div(
          class: "ml-3 border-neutral-300 border-l border-b col-start-2 col-span-2 hidden peer-checked:block",
          summary-renderer(it.children, current-chapter),
        )
      },
  )
}

#let flatten-tree(tree) = {
  let out = ()
  for it in tree {
    let base = it
    if "children" in base {
      let _ = base.remove("children")
      out.push(base)
      out += flatten-tree(it.children)
    } else {
      out.push(base)
    }
  }
  out
}

#let footer-renderer(final-tree, current) = html.footer(
  class: "mt-8 grid grid-cols-1 md:grid-cols-[1fr_1fr] gap-4",
  {
    // TODO: change this to dictionary based
    let flattened = flatten-tree(final-tree).filter(it => it.kind == "chapter")
    let current-idx = flattened.position(it => it.page-label == current.page-label)
    let link-classes = "[&>a]:no-underline border-1 border-neutral-300 hover:bg-neutral-100 hover:shadow-xs [&>a]:block [&>a]:w-full [&>a]:h-full [&>a]:p-4 "
    if current-idx == none {
      return
    }
    if current-idx > 0 {
      let info = flattened.at(current-idx - 1)
      html.div(
        class: link-classes,
        link(info.page-label, info.title),
      )
    }
    if current-idx < flattened.len() - 1 {
      let info = flattened.at(current-idx + 1)
      html.div(
        class: "md:col-start-2 text-right " + link-classes,
        link(info.page-label, info.title),
      )
    }
    html.span(class: "md:col-span-2 text-xs text-center")[
      Powered by #link("https://github.com/wensimehrp/otter-docs")[Otter Docs]. Made in Vancouver with love.
    ]
  },
)

#let internal-html-renderer(final-tree, it) = html.div({
  import html: *
  let footnote-state = state(str(it.page-label) + " Footnote State", ())
  // discard auto generated footnote entries since we manually display them
  show footnote: it => span(class: "footnote", {
    footnote-state.update(state => state + (it,))
    let len = footnote-state.get().len()
    sup(id: "footnote-ref-" + str(len), a(
      href: "#footnote-source-" + str(len),
      numbering(it.numbering, len + 1),
    ))
    span(
      class: "footnote-popup",
      it.body,
    )
  })

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
          summary-renderer(final-tree, it)
        },
      )
    },
  )
  article(
    class: "p-3 sm:p-6 md:p-8 max-w-[52rem] md:ml-72 prose prose-neutral leading-normal prose-pre:bg-neutral-100 prose-pre:text-neutral-900 prose-pre:rounded-none font-[450]",
    {
      it.content
      // footnote
      let final = footnote-state.final()
      if final.len() > 0 {
        section(class: "border-t border-neutral-300 text-sm text-neutral-500", ol(class: "list-none pl-0", for (
          idx,
          note,
        ) in final.enumerate() {
          li(
            id: "footnote-source-" + str(idx),
            sup(a(
              href: "#footnote-ref-" + str(idx),
              numbering(note.numbering, idx + 1),
            ))
              + note.body,
          )
        }))
      }
      // footer
      footer-renderer(final-tree, it)
    },
  )
})

#let update-elem(elem, state: none) = {
  let classes = elem.fields().attrs.at("class", default: ())
  if type(classes) == array {
    classes = classes.join(" ")
  }
  state.update(it => it + " " + classes)
  elem
}

#let recursive-html-renderer(final-tree, current-tree, lang, stylesheet) = for it in current-tree {
  if it.kind == "chapter" [
    #let path-str = "/" + it.path.join("/") + ".html"
    #document(
      path-str,
      html.html(lang: lang, {
        import html: *
        head({
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width, initial-scale=1")
          title(it.title)
          // TODO: finish description here
          meta(name: "description", content: "...")
          stylesheet
        })
        internal-html-renderer(final-tree, it)
      }),
    ) #it.page-label
  ]
  recursive-html-renderer(
    final-tree,
    it.at("children", default: ()),
    lang,
    stylesheet,
  )
}


#let html-renderer(tree, lang: "en", root: (), ..args) = {
  // first generate the tailwind preflight
  import "@local/typhoon:0.1.2"
  let stylesheet-path = "/" + root.join("/") + "/styles.css"
  let page-classes = state("__new_hamber page classes", "")
  asset(
    stylesheet-path,
    typhoon._plugin.generate(bytes(page-classes.final()), cbor.encode((
      preflight: (full: (font_family_sans: "Cabin")),
    )))
      + bytes("\n")
      + read("footnote.css", encoding: none),
  )
  // then generate html files
  show html.elem: update-elem.with(state: page-classes)
  recursive-html-renderer(
    tree,
    tree,
    lang,
    // to prevent too much bloat in html files
    // and to reuse the classes
    {
      html.link(rel: "stylesheet", href: stylesheet-path)
      html.style(
        "@import url('https://fonts.googleapis.com/css2?family=Cabin:ital,wght@0,400..700;1,400..700&display=swap');",
      )
    },
  )
}


#let paged-renderer(tree, root: (), ..args) = [#document(root.join("/") + "/doc.pdf", for it in flatten-tree(tree) {
  it.content
}) <doc.pdf>]
