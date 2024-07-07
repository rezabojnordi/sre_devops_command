// ssr plugin

//validator
import { Form, Field } from 'vee-validate'

export default defineNuxtPlugin((NuxtApp) => {
  NuxtApp.vueApp.component('Form', Form)
  NuxtApp.vueApp.component('Field', Field)
})
