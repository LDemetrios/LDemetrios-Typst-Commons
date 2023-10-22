#let MAX = 9223372036854775807
#let MIN = -9223372036854775807 - 1
#let HALF = 4294967296
#let HALF_MAX = 2147483647
#let HALF_MIN = -2147483648

#let Long_add(a, b) = if (a <= 0 and b >= 0 or a >= 0 and b <= 0) { a + b } else if (a > 0) {
  // a + (MAX - a) - (MAX - a) + b
  // b + MAX + 1 - 1 - (MAX - a)
  // b + MIN - 1 - (MAX - a)
  //if(a + b > MAX)
  if (a > MAX - b) {
    a + MIN + b + MIN
  } else {
    a + b
  }
} else {
  if (a < MIN - b) {
    a - MIN + b - MIN
  } else {
    a + b
  }
}

#let Long_negate(a) = if (a == MIN) { MIN } else { -a }

#let Long_sub(a, b) = Long_add(a, Long_negate(b))

#let __to-ints(a) = {
  let al = calc.rem(a, HALF)
  if (al < HALF_MIN) { al += HALF }
  if (al > HALF_MAX) { al -= HALF }
  let ah = calc.quo(Long_sub(a, al), HALF)
  return (al, ah)
}

#let Long_mul(a, b) = {
  let (al, ah) = __to-ints(a)
  let (bl, bh) = __to-ints(b)

  let albl = al * bl
  let albh = al * bh
  let ahbl = ah * bl

  let (albl_l, albl_h) = __to-ints(albl)
  let (albh_l, _) = __to-ints(albh)
  let (ahbl_l, _) = __to-ints(ahbl)

  let low = albl_l
  let high = albl_h + albh_l + ahbl_l

  while (high < HALF_MIN) {
    high += HALF
  }
  while (high > HALF_MAX) {
    high -= HALF
  }

  return Long_add(high * HALF, low)
}

#let Long_div(a, b) = if (a == MIN and b == -1) { MIN } else { calc.quo(a, b) }

#let Long_to-int(a) = {
  let res = calc.rem(a, HALF)
  if (res > HALF_MAX) { res -= HALF }
  if (res < HALF_MIN) { res += HALF }
  res
}

#let Long_shr(a, s) = Long_div(a, calc.pow(2, s))
#let Long_ushr(a, s) = {
  if (s == 0) {
    a
  } else {
    s- = 1
    a /= 2
    if (a < 0) { a -= MIN }
    shr(a, s)
  }
}
#let Long_shl(a, s) = Long_mul(a, calc.pow(2, s))

#let Long = (
  add: Long_add,
  sub: Long_sub,
  mul: Long_mul,
  negate: Long_negate,
  div: Long_div,
  shl: Long_shl,
  shr: Long_shr,
  ushr: Long_shr,
  to-int: Long_to-int,
)

#let __int-op(a, b, op) = {
  Long_to-int(op(Long_to-int(a), Long_to-int(b)))
}
#let Int_add(a, b) = __int-op(a, b, (x, y) => x + y)
#let Int_sub(a, b) = __int-op(a, b, (x, y) => x - y)
#let Int_mul(a, b) = __int-op(a, b, (x, y) => x * y)
#let Int_div(a, b) = __int-op(a, b, calc.quo)
#let Int_negate(a) = Long_to-int(Long_negate(a))
#let Int_shr(a, s) = Long_to-int(Long_shr(a, s))
#let Int_ushr(a, s) = Long_to-int(Long_ushr(a, s))
#let Int_shl(a, s) = Long_to-int(Long_shl(a, s))

#let Int = (
  add: Int_add,
  sub: Int_sub,
  mul: Int_mul,
  negate: Int_negate,
  div: Int_div,
)

#let bitwise(a, b, op) = {
  let asign = if a < 0 { 1 } else { 0 }
  let bsign = if b < 0 { 1 } else { 0 }
  if a < 0 { a -= MIN }
  if b < 0 { b -= MIN }
  let res = 0
  let multiplier = 1
  for i in range(0, 64) {
    res = Long_add(Long_mul(op(calc.rem(a, 2), calc.rem(b, 2)), multiplier), res)
    a = calc.quo(a, 2)
    b = calc.quo(b, 2)
    multiplier = Long_mul(multiplier, 2)
  }
  if (op(asign, bsign) == 1) { res += MIN }
  res
}

#let band(a, b) = bitwise(a, b, (x, y) => x * y)
#let bor(a, b) = bitwise(a, b, (x, y) => x + y - x * y)
#let bxor(a, b) = bitwise(a, b, (x, y) => x + y - 2 * x * y)
#let bnot(a) = bitwise(a, 0, (x, y) => 1 - x)
