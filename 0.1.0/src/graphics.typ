#import "@preview/cetz:0.1.2"

#import "vectors.typ" : *

#let bezier-curve(steps: 100, coords, ..args) = {
  let pow(a, b) = if (b == 0) { 1 } else { calc.pow(a, b) }

  let bezier-timed(coords, n, cn, t, c) = {
    let sum = .0
    for i in range(0, n + 1) {
      sum += cn.at(i) * pow(t, i) * pow(1 - t, n - i) * coords.at(i).at(c)
    }
    sum
  }

  let n = coords.len() - 1
  let points = coords
  let cn = (1,)
  for k in range(1, n + 1) {
    cn.push(cn.at(k - 1) * (1 - k + n) / k)
  }
  let step = 1.0 / steps
  let prevX = points.at(0).at(0)
  let prevY = points.at(0).at(1)
  for i in range(steps) {
    let x = bezier-timed(points, n, cn, step * (i + 1), 0)
    let y = bezier-timed(points, n, cn, step * (i + 1), 1)
    cetz.draw.line((prevX, prevY), (x, y), ..args)
    prevX = x
    prevY = y
  }
}

#let arc0(from, to, delta, ..args) = {
  import cetz.draw: *

  get-ctx(ctx => {
    let (fromx, fromy, fromz) = cetz.coordinate.resolve(ctx, from)
    let (tox, toy, toz) = cetz.coordinate.resolve(ctx, to)

    let a = (x: fromx, y: fromy)
    let b = (x: tox, y: toy)
    let middle = div-v(add-v(a, b), 2)
    // radius * (1 - cos alpha) = delta * |b - a|
    // radius * sin alpha = |b - a| / 2
    let dist = mod-v(sub-v(b, a))
    // (1 - cos a) / sin a = 2 * delta
    let alpha = 2 * calc.atan(2 * delta)
    let radius = dist / 2 / calc.sin(alpha)
    let median = ort-v(rot-v(sub-v(middle, b)))
    let median-angle = calc.atan2(-median.x, median.y)
    let center = add-v(mlt-v(median, radius * calc.cos(alpha)), middle)
    arc(
      a,
      stop: (median-angle - alpha),
      start: (median-angle + alpha),
      radius: radius,
      ..args,
    )
  })
}

#let arrow(from, to, arrowhead-size, arrowhead-angle, name: none, fill-arrowhead:none, ..args) = {
  import cetz.draw: *
  get-ctx(ctx => {
    let (fromx, fromy, fromz) = cetz.coordinate.resolve(ctx, from)
    let (tox, toy, toz) = cetz.coordinate.resolve(ctx, to)

    let a = (x: fromx, y: fromy)
    let b = (x: tox, y: toy)

    let v-ab = ort-v(sub-v(b, a))
    let arrowhead-back = sub-v(b, mlt-v(v-ab, arrowhead-size))
    let orthogonal = rot-v(v-ab)
    let back-size = calc.sin(arrowhead-angle) * arrowhead-size
    line(a, b, name: name, ..args)
    if fill-arrowhead == none {
    line(
      b,
      add-v(arrowhead-back, mlt-v(orthogonal, back-size)),
      sub-v(arrowhead-back, mlt-v(orthogonal, back-size)),
      close:true,
      ..args,
    )
    } else {
      line(
      b,
      add-v(arrowhead-back, mlt-v(orthogonal, back-size)),
      sub-v(arrowhead-back, mlt-v(orthogonal, back-size)),
      close:true,
      fill:fill-arrowhead,
      ..args,
    )
    }
  })
}
