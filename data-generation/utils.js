export function random (from = 0, to = 1) {
  return from + (to - from)*Math.random()
}

export function randomInt (from = 0, to = 1) {
  return Math.round((from - 0.5) + (to - from + 1) * Math.random())
}

export function randomFrom (arr) {
  return arr[randomInt(0, arr.length - 1)]
}

export function createCounter (startValue = 0) {
  let init = startValue
  return () => {
    return init++
  }
}

export const generateSurnameRu = (i) => `Фурман-${i}`
export const generateNameRu = (i) => `Владос-${i}`
export const generatePatronimRu = (i) => `Бандос-${i}`

export const generateSurnameEn = (i) => `Norris-${i}`
export const generateNameEn = (i) => `Chuck-${i}`

export const generateEmail = (i) => `jija-${i}@kek.com`
export const generatePhoneNumber = (i) => `8 (999) 666 ${i}`
