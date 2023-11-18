
#let add-v(a, b) = (x: (a.x + b.x), y: (a.y + b.y))
#let sub-v(a, b) = (x: (a.x - b.x), y: (a.y - b.y))
#let mlt-v(a, b) = {
  if (type(a) == dictionary) {
    (x: (a.x * b), y: (a.y * b))
  } else {
    (x: (a * b.x), y: (a * b.y))
  }
}
#let div-v(a, b) = {
  if (type(a) == dictionary) {
    (x: (a.x / b), y: (a.y / b))
  } else {
    (x: (b.x / a), y: (b.y / a))
  }
}
#let scl-v(a, b) = a.x * b.x + a.y * b.y
#let mod-v(a) = calc.sqrt(scl-v(a, a))
#let ort-v(a) = div-v(a, mod-v(a))
#let rot-v(a) = (x: (-a.y), y: (-a.x))

