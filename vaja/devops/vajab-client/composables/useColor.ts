export function randomColorHex(): string {
  return '#' + ((Math.random() * 0xffffff) << 0).toString(16)
}

export function colorifyString(str: string): string {
  // Convert the string to a hash code
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash)
  }

  // Convert the hash code to a hex color
  let color = '#'
  for (let i = 0; i < 3; i++) {
    const value = (hash >> (i * 8)) & 0xff
    color += value.toString(16).padStart(2, '0')
  }

  return color
}

export function stringToColorHSL(
  str: string,
  saturation = 100,
  lightness = 75
): string {
  let hash = 2166136261
  for (let i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i)
    hash *= 16777619
  }
  hash = hash >>> 0 // Convert to 32-bit unsigned integer
  hash += 100
  return `hsl(${hash % 360}, ${saturation - (hash % 100)}%, ${
    lightness - (hash % 50)
  }%)`
}
