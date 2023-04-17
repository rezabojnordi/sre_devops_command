import * as vt from 'vue-toastification'
import '@/assets/styles/toast.scss'
export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.use(vt.default, {
    rtl: true,
    position: 'bottom-right',
  })
  return {
    provide: {
      toast: vt.useToast(),
    },
  }
})
