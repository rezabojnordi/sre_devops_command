// ssr plugin
// filters & globalPropertis

import moment from 'jalali-moment'

export default defineNuxtPlugin((NuxtApp) => {
  NuxtApp.vueApp.config.globalProperties.$focus = (id: string) => {
    setTimeout(() => {
      if (document.getElementById(id)) {
        document.getElementById(id)!.focus()
      }
    }, 100)
  }

  NuxtApp.vueApp.config.globalProperties.$filters = {
    toEn(num: [number, string]) {
      if (!num) {
        return
      }
      const arr: any[] = []
      const persian = {
        '۰': 0,
        '۱': 1,
        '۲': 2,
        '۳': 3,
        '۴': 4,
        '۵': 5,
        '۶': 6,
        '۷': 7,
        '۸': 8,
        '۹': 9,
      }
      String(num)
        .split('')
        .map((number: string, index: number) => {
          const key = number as keyof typeof persian
          arr[index] = persian[key] >= 0 ? persian[key] : number
        })
      return arr.join('')
    },

    jalaliMoment(date: string, format: string) {
      if (date) {
        const m = moment(date, 'YYYY/M/D')
        return m.locale('fa').format(format)
      }
    },

    cardNumberMask(cardNumber: string) {
      if (!cardNumber || cardNumber === '') {
        return ''
      }
      const hideNum = []
      for (let i = 0; i < cardNumber.length; i++) {
        if (i < cardNumber.length - 4 && i > 3) {
          hideNum.push('*')
        } else {
          hideNum.push(cardNumber[i])
        }
      }
      return hideNum.join('')
    },

    toCurrency(str: string) {
      if (str) {
        str = String(str)
        const points = str.split('.')[1] ? `.${str.split('.')[1]}` : ''
        str = str.split('.')[0]
        str = str.replace(/\,/g, '')
        const objRegex = new RegExp('(-?[0-9]+)([0-9]{3})')
        while (objRegex.test(str)) {
          str = str.replace(objRegex, '$1,$2')
        }
        return str + points
      } else {
        return str
      }
    },
  }

  NuxtApp.vueApp.config.globalProperties.$getImageUrl = (address: string) => {
    return new URL(address, import.meta.url).href
  }
  NuxtApp.vueApp.config.globalProperties.$isSm = () => {
    const windowWidth = ref(window.innerWidth)

    const onWidthChange = () => (windowWidth.value = window.innerWidth)
    onMounted(() => window.addEventListener('resize', onWidthChange))
    onUnmounted(() => window.removeEventListener('resize', onWidthChange))

    const type = computed(() => {
      if (windowWidth.value <= 768) return true
      return false // This is an unreachable line, simply to keep eslint happy.
    })
    return type
  }
})
