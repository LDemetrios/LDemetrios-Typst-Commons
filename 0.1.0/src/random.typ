#let multiplier = 25214903917
#let uniquifierMultiplier = 1181783497276652981
#let addend = 11
#let mask = 281474976710655
#let DOUBLE_UNIT = 1.110223024625156
#let FLOAT_UNIT = 5.9604645E-8
#let seedUniquifier = 8682522807148012

#import "Long.typ" 
#let (add, sub, mul, negate, div, shl, shr, ushr, to-int) = (Long.add, Long.sub, Long.mul, Long.negate, Long.div, Long.shl, Long.shr, Long.ushr, Long.to-int) 

#let Rnd_initial-scramble(seed) = seed.bit-xor(multiplier).bit-and(mask)

#let new-Random(seed: none) = {
  (seed: Rnd_initial-scramble(if(seed == none) {seedUniquifier} else {seed}))
}

#let Rnd_set-seed(this, seed) = {
  this.seed = Rnd_initial-scramble(seed)
  this.haveNextNextGaussian = false
  this
}

#let Rnd_next(this, bits) = {
  this.seed =    add(mul(this.seed, multiplier), addend).bit-and( mask)
  let res = to-int(ushr(this.seed, 48 - bits))
  (this, res)
}

#let Rnd_next-int(this, bound: none) = {
  if (bound == none) { Rnd_next(this, 32) } else {
    assert(bound > 0)
    let r = 0
    (this, r) = Rnd_next(this, 31)
    let m = bound - 1
    if (bound.bit-and(m) == 0) {
      r = to-int(shr(mul(bound, r), 31))
    } else {
      let u = r
      while (u - calc.rem(u, bound) + m < 0) {
        (this, u) = Rnd_next(this, 31)
      }
      r = calc.rem(u, bound)
    }
    (this, r)
  }
}

#let Rnd_next-long(this) = {
  let (this, a) = Rnd_next(this, 32)
  let (this, b) = Rnd_next(this, 32)
  let res = add(shl(a, 32), b)
  (this, res)
}

#let Rnd_next-boolean(this) = {
  let (this, i) = Rnd_next(this, 1)
  (this, i != 0)
}
#let Rnd_next-float(this) = {
  let (this, i) = Rnd_next(this, 24)
  (this, i * FLOAT_UNIT)
}
#let Rnd_next-double(this) = {
  let (this, a) = Rnd_next(this, 26)
  let (this, b) = Rnd_next(this, 27)
  let res = add(shl(a, 27), b) * DOUBLE_UNIT
  (this, res)
}
#let random = state("random", (new-Random(seed: seedUniquifier), 0))

#let identity(x) = [#x]

#let set-seed(seed) = {
  random.update((entry) => { (Rnd_set-seed(entry.at(0), seed), entry.at(1)) })
}

#let __rnd-op(op, f, ..args) = {
  random.update((entry) => { op(entry.at(0), ..args) })
 f(random.get().at(1))
}

#let next(bits, f: identity) = __rnd-op(Rnd_next, f, bits)

#let next-int(bound: none, f: identity) = __rnd-op(Rnd_next-int, f, bound: bound)

#let next-long(f: identity) = __rnd-op(Rnd_next-long, f)

#let next-boolean(f: identity) = __rnd-op(Rnd_next-boolean, f)

#let next-float(f: identity) = __rnd-op(Rnd_next-float, f)

#let next-double(f: identity) = __rnd-op(Rnd_next-double, f)
