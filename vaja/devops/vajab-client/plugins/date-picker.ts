// client side plugin

import VuePersianDatetimePicker from 'vue3-persian-datetime-picker'

export default defineNuxtPlugin((NuxtApp) => {
  NuxtApp.vueApp.component('DatePicker', VuePersianDatetimePicker)
})
