#let quat(r, x, y, z) = (r: r, x: x, y: y, z: z)
#let has(di, key) = di.at(key, default: 0) == di.at(key, default: 1)
#let is_quat(a) = has(a, "r") and has(a, "x") and has(a, "y") and has(a, "z")

#let _qadd(a, b) = quat(a.r + b.r, a.x + b.x, a.y + b.y, a.z + b.z)
#let _qsub(a, b) = quat(a.r - b.r, a.x - b.x, a.y - b.y, a.z - b.z)
#let _qneg(b) = quat(- b.r, - b.x, - b.y, - b.z)
#let _qconj(a) = quat(a.r, - a.x, - a.y, - a.z)
#let _qmul(a, b) = {
  let a1 = a.r
  let a2 = b.r
  let b1 = a.x
  let b2 = b.x
  let c1 = a.y
  let c2 = b.y
  let d1 = a.z
  let d2 = b.z

  let qa = a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2
  let qb = a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2
  let qc = a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2
  let qd = a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2

  return quat(qa, qb, qc, qd)
}

#let _qimul(a, k) = quat(a.r * k, a.x * k, a.y * k, a.z * k)
#let _qnorm(a) = _qmul(a, _qconj(a)).r
#let _qinv(a) = _qimul(_qconj(a), 1 / _qnorm(a))
#let _qdiv(a, b) = _qmul(a, _qinv(b))
#let _qnormalize(a) = _qimul(a, 1 / calc.sqrt(_qnorm(a)))

#let ii = quat(0, 1, 0, 0)
#let jj = quat(0, 0, 1, 0)
#let kk = quat(0, 0, 0, 1)

#let quaternion(..args) = {
  let pos = args.pos();
  if pos.len() == 0 {
    return quat(0, 0, 0, 0)
  } else if pos.len() == 1 {
    let it = pos.at(0)
    if type(it) == int or type(it) == float {
      return quat(it, 0, 0, 0)
    } else if type(it) == array {
      return quaternion(..it)
    } else if is_quat(it) {
      return it
    } else {
      assert(false, message:"can't convert to quaternion: " + repr(it))
    }
  } else if pos.len() == 4 {
    let number(it) = type(it) == int or type(it) == float
    assert(number(pos.at(0)), message:"error converting " + repr(pos) + " to quaternion")
    assert(number(pos.at(1)), message:"error converting " + repr(pos) + " to quaternion")
    assert(number(pos.at(2)), message:"error converting " + repr(pos) + " to quaternion")
    assert(number(pos.at(3)), message:"error converting " + repr(pos) + " to quaternion")
    quat(pos.at(0), pos.at(1), pos.at(2), pos.at(3))
  } else/* if pos.len(at) == */ {
    // Maybe add clauses later
    assert(false,message: "can't convert to quaternion: " + repr(pos))
  }
}

#let _quop(op) = (it) => op(quaternion(it))
#let qneg = _quop(_qneg)
#let qinv = _quop(_qinv)
#let qconj = _quop(_qconj)
#let qnorm = _quop(_qnorm)
#let qnormalize = _quop(_qnormalize)

#let _qbop(op) = (a, b) => op(quaternion(a), quaternion(b))
#let qadd = _qbop(_qadd)
#let qsub = _qbop(_qsub)
#let qmul = _qbop(_qmul)
#let qdiv = _qbop(_qdiv)

#let qrotational(axis, alpha) = {
  let u = qnormalize(quaternion(0, ..axis))
  let s = calc.sin(alpha/2)
  let c = calc.cos(alpha/2)
  quat(c, u.x * s, u.y * s, u.z * s)
}

#let q-to-str(q) = $#q.r + #q.x II + #q.y JJ + #q.z KK$
