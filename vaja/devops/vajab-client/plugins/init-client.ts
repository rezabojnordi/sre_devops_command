// client-side plugin

import { authenticationStore } from '~~/stores/authentication'

export default defineNuxtPlugin((NuxtApp) => {
  const store = authenticationStore()
  if (store.getToken) {
    // store.getUserInfo()
  }
})
