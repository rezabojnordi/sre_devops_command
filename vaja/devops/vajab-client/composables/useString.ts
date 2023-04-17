export interface easyReadNumberInterface {
  show: string
  real: number
}

export function easyReadNumber(
  str: string | number,
  decimal: number
): easyReadNumberInterface {
  let num
  if (typeof str === 'string') {
    num = parseFloat(str)
    if (isNaN(num)) {
      return {
        show: '0',
        real: 0,
      }
    }
  } else {
    num = str
  }
  const formatter = new Intl.NumberFormat(undefined, {
    // These options are needed to round to whole numbers if that's what you want.
    // minimumFractionDigits: decimal, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
    maximumFractionDigits: decimal, // (causes 2500.99 to be printed as $2,501)
  })

  return {
    show: formatter.format(num),
    real: num,
  }
}

export function faNumToEn(str: string) {
  const persianNumbers = [
    /۰/g,
    /۱/g,
    /۲/g,
    /۳/g,
    /۴/g,
    /۵/g,
    /۶/g,
    /۷/g,
    /۸/g,
    /۹/g,
  ]
  const arabicNumbers = [
    /٠/g,
    /١/g,
    /٢/g,
    /٣/g,
    /٤/g,
    /٥/g,
    /٦/g,
    /٧/g,
    /٨/g,
    /٩/g,
  ]

  if (typeof str === 'string') {
    for (let i = 0; i < 10; i++) {
      str = str
        .replace(persianNumbers[i], i.toString())
        .replace(arabicNumbers[i], i.toString())
    }
  }
  return str
}
