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

#let centbox(body) = align(center)[
  #box[
    #align(left)[
      #body
    ]
  ]
]

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

#let slfrac(a, b) = box(baseline: 50% - 0.3em)[
  #cetz.canvas({
    import cetz.draw : *
    content((0, 0), a, anchor: "bottom-right")
    line((.5em, .5em), (-.2em, -1em), stroke: 1pt)
    content((.35em, -.4em), b, anchor: "top-left")
  })
]

#let cyrsmallcaps(body) = [
  #show regex("[а-яё]") : it => text(size: .7em, upper(it))
  #body
]

#let showtheme(
  base: none,
  fill: none,
  surface: none,
  high: none,
  subtle: none,
  overlay: none,
  iris: none,
  foam: none,
  fnote: none,
) = body => [

  #let decide(on, whatif) = if (on == none) { body => body } else { whatif }
  #let either(..a) = if (a.pos().contains(none)) { none } else { 1 }

  #show: decide(base, (body) => { set page(fill: base); body })
  #show: decide(fill, (body) => { set text(fill: fill); body })
  #show:decide(subtle, (body) => { set line(stroke: subtle);body })
  #show : decide(either(subtle, overlay), (body) => {
    set circle(stroke: subtle, fill: overlay)
    set ellipse(stroke: subtle, fill: overlay)
    set path(stroke: subtle, fill: overlay)
    set polygon(stroke: subtle, fill: overlay)
    set rect(stroke: subtle, fill: overlay)
    set square(stroke: subtle, fill: overlay)
  })
  #show : decide(high, (body) => { set highlight(fill: highlight.high); body })
  #show : decide(
    either(surface, high),
    (body) => { set table(fill: surface, stroke: highlight.high); body },
  )

  #show link: decide(iris, (body) => { set text(fill: iris); body })
  #show ref: decide(foam, (body) => { set text(fill: foam); body })
  #show footnote: decide(fnote, (body) => { set text(fill: fnote); body })

  #body
]

#let all-math-display = rest => [
  #show math.equation: it => {
    if it.body.fields().at("size", default: none) != "display" {
      math.display(it)
    } else {
      it
    }
  }
  #rest
]

#let TODO(x) = rect(width: 100%, height: 5em, fill: luma(255 - 235), stroke: 1pt + white)[
  #set align(center + horizon)
  #text(size: 1.5em, "TODO!")\ #x
]

#let smallcaps-headings(..level-descriptions) = (body) => {
  let descr = level-descriptions.pos()
  show heading : (it) => [
    #set text(size: descr.at(it.level - 1).at(0))
    #set align(descr.at(it.level - 1).at(1))
    #it
  ]
  cyrsmallcaps(body)
}
