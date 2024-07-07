import Axios from 'axios'
import { authenticationStore } from '~/stores/authentication'
import { appStore } from '~/stores/app'

const axios = Axios.create({
  baseURL: 'http://192.168.8.67:3007/v1',
  headers: {
    Authorization: '',
  },
})

// get fresh accessToken is running flag
let isRefreshing = false
// 401 requests stack
let apiCallStack: any = []

// on each request
axios.interceptors.request.use(
  async (config) => {
    const authStore = authenticationStore()
    config.headers.Authorization = `Bearer ${authStore.getToken}`
    return config
  },
  (error) => {
    Promise.reject(error)
  }
)

// on any response
axios.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    // handle unauthed requests
    const authStore = authenticationStore()
    const originalConfig = error.config
    if (error.response && authStore.getToken) {
      // if 401 & not retry & it`s not getFreshToken req
      if (
        error.response.status === 401 &&
        !originalConfig._retry &&
        originalConfig.url !== 'account/refresh"'
      ) {
        originalConfig._retry = true
        // push to unauthed request
        apiCallStack.push(originalConfig)
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
                apiCallStack = []
              }
              appStore().handleError(error)
            })
            .finally(() => {
              isRefreshing = false
            })
        }
      }

      if (error.response.status !== 401) {
        // none of refresh token businnes
        appStore().handleError(error)
        return Promise.reject(error.response.data)
      }
    } else {
      appStore().handleError(error)
    }
    return Promise.reject(error)
  }
)

// run unauthed reqs func
function resolveAllRequest() {
  apiCallStack.forEach((cb: any) => axios(cb))
  apiCallStack = []
}

// import & use api then enjoy err handling :)
export const api = axios
