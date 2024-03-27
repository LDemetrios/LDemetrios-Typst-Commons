#let dx = $upright(d)x$
#let dy = $upright(d)y$
#let dz = $upright(d)z$
#let dw = $upright(d)w$
#let du = $upright(d)u$
#let dv = $upright(d)v$
#let dp = $upright(d)p$
#let dt = $upright(d)t$

#let dcases(delim: "{", reverse: false, gap: 0.5em, ..children) = math.cases(
  delim: delim,
  reverse: reverse,
  gap: gap,
  ..children.pos().map(math.display),
)
