export function safeDiv(num: number, denom: number): number {
  if (num == null || isNaN(num)) {
    return 0
  }
  if (denom === null || isNaN(denom)) {
    return 0
  }
  const result = num / denom
  if (!isFinite(result)) {
    return 0
  }
  return result
}

export function toFixedNumber(num: number, digits: number, base = 10) {
  const pow = Math.pow(base, digits)
  return Math.round(num * pow) / pow
}
