#import "@preview/tablex:0.0.5": *
#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx, hlinex, vlinex

#let conf(title: none, authors: (), abstract: [], doc) = {
  set page(
    paper: "us-letter",
    header: align(right + horizon, title),
    numbering: "1",
  )

  set par(justify: true)
  set text(font: "Linux Libertine", size: 11pt)

  // Heading show rules.
  show heading.where(level: 1): it => block(width: 100%)[
    #set align(center)
    #set text(12pt, weight: "regular")
    #smallcaps(it.body)
  ]

  show heading.where(level: 2): it => text(size: 11pt, weight: "regular", style: "italic", it.body + [.])

  set align(center)
  text(17pt, title)

  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(columns: (1fr,) * ncols, row-gutter: 24pt, ..authors.map(author => [
    #author.name \
    #author.affiliation \
    #link("mailto:" + author.email)
  ]))

  par(justify: false)[
    *Abstract* \
    #abstract
  ]

  set align(left)
  columns(2, doc)
}

#let nobreak(body) = block(breakable: false, body)

#let quote(pref: none, author: none, text) = {
  [#pref]
  tablex(
    columns: (.7em, .4em, 1fr),
    align: left + horizon,
    auto-vlines: false,
    auto-hlines: false,
    [],
    vlinex(start: 0, end: 1, stroke: rgb("#aaaaaa") + 3pt),
    [],
    [
      #text
      #if author != none {
        align(right)[--- _ #author _]
      }
    ],
  )
}

#import "@preview/rose-pine:0.1.0": apply, rose-pine-dawn, rose-pine-moon, rose-pine, apply-theme
#let dark-theme = apply(variant: "rose-pine-moon")

#let slfrac(a, b) = box(baseline:50% - 0.3em)[
#cetz.canvas({
  import cetz.draw : *
  content((0, 0), a, anchor:"bottom-right")
  line((.5em, .5em), (-.2em, -1em), stroke:1pt)
  content((.35em, -.4em), b, anchor:"top-left")
})]

#let cyrsmallcaps(body) = [
  #show regex("[а-яё]") : it => text(size:.7em, upper(it))
  #body
]
