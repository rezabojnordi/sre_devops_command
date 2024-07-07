// ssr plugin

import { authenticationStore } from '~~/stores/authentication'

export default defineNuxtPlugin((NuxtApp) => {
  authenticationStore().initAuth(NuxtApp.ssrContext?.event.node.req)
})
