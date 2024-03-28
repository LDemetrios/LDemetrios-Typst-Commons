#import "@preview/tablex:0.0.6": *

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
    #cyrsmallcaps(it)
  ]
  body
}

#let lucid(x) = color.mix((text.fill, 255 - x), (page.fill, x))

// author: gaiajack
#let labeled-box(lbl, body) = block(above: 2em, stroke: 0.5pt + foreground, width: 100%, inset: 14pt)[
  #set text(font: "Noto Sans")
  #place(
    top + left,
    dy: -.8em - 14pt, // Account for inset of block
    dx: 6pt - 14pt,
    block(fill: background, inset: 2pt)[*#lbl*],
  )
  #body
]

#let marked(fill: auto, stroke, body) = context {
  let fill2 = if fill == auto { lucid(230) } else {fill}
  let stroke = if type(stroke) == length {
    foreground + stroke
  } else if type(stroke) == color {
    stroke + 0.25em
  } else {
    stroke
  }
  rect(fill: fill2, stroke: (left: stroke), width: 100%, body)
}

#let quote(pref: none, author: none, body) = {
  [#pref]
  context marked(fill: lucid(180), text.fill + 3pt)[
    #body
    #if author != none {
      align(right)[--- _ #author _]
    }
  ]
}

#let nobreak(body) = block(breakable: false, body)

#let centbox(body) = align(center)[
  #box[
    #align(left)[
      #body
    ]
  ]
]

#let offset(off, ..args, body) = pad(left: 2em, ..args, body)

