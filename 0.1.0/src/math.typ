#let dx = $upright(d)x$
#let dy = $upright(d)y$
#let dz = $upright(d)z$
#let dw = $upright(d)w$
#let du = $upright(d)u$
#let dv = $upright(d)v$
#let dp = $upright(d)p$
#let dt = $upright(d)t$
#let da = $upright(d)a$
#let db = $upright(d)b$
#let dc = $upright(d)c$
#let dd = $upright(d)d$

#let dcases(delim: "{", shift: 1em, reverse: false, gap: 0.5em, ..children) = text(
  size: shift,
  math.cases(
    delim: delim,
    reverse: reverse,
    gap: gap,
    ..children.pos().map(it => math.display(text(size: 1em / (shift / 1em), it))),
  ),
)