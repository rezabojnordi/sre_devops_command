import AccountModule from '~/repository/account/bankcard'
import { authenticationStore } from '~/stores/authentication'
import { $fetch, FetchOptions, FetchRequest } from 'ohmyfetch'
import { appStore } from '~/stores/app'

interface ApiInstanceInterface {
  account: AccountModule
}

export default defineNuxtPlugin((nuxtApp) => {
  let isRefreshing = false
  const apiCallStack = new Map<FetchRequest, FetchOptions>()

  const fetchOptions: FetchOptions = {
    baseURL: nuxtApp.$config.API_BASE_URL,
    headers: {
      Authorization: `Bearer ${authenticationStore().getToken}`,
    },
    async onResponseError(ctx): Promise<void> {
      const authStore = authenticationStore()

      if (ctx.response.status === 401) {
        apiCallStack.set(ctx.request, ctx.options)
        if (!isRefreshing) {
          isRefreshing = true
          authStore
            .getFreshAccessTokenRequest()
            .then(() => {
              // run unauthed requests after get new access token
              resolveAllRequest()
            })
            .catch((error) => {
              if (error.response.status === 401) {
                authStore.loggedOut()
                apiCallStack.clear()
              }
              appStore().handleError(error)
            })
            .finally(() => {
              isRefreshing = false
            })
        }
      }
    },
  }

  // run unauthed reqs func
  async function resolveAllRequest() {
    for (const [req, opt] of apiCallStack) {
      await $fetch(req, opt)
    }
    apiCallStack.clear()
  }

  /** create axios instance */
  const apiFetcher = $fetch.create(fetchOptions)

  const modules: ApiInstanceInterface = {
    account: new AccountModule(apiFetcher),
  }

  return {
    provide: {
      api: modules,
    },
  }
})
