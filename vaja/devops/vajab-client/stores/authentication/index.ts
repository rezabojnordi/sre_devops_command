import { defineStore } from 'pinia'
import { api } from '@/services/axios'
import Cookie from 'js-cookie'

export const authenticationStore = defineStore('authentication', {
  state: () => ({
    token: '',
    refreshToken: '',
    user: {},
    status: false,
  }),

  getters: {
    getUser(state) {
      return state.user
    },
    isLoggedIn(state) {
      return state.token !== null && state.token.length > 0
    },
    getToken(state) {
      return state.token
    },
    getRefreshToken(state) {
      return state.refreshToken
    },
  },

  actions: {
    initAuth(req: any) {
      if (req && req.headers) {
        if (!req.headers.cookie) {
          return
        }

        const token = req.headers.cookie
          .split(';')
          .find((c: string) => c.trim().startsWith('token='))

        const refreshToken = req.headers.cookie
          .split(';')
          .find((c: string) => c.trim().startsWith('refreshToken='))

        // const lang = req.headers.cookie
        // .split(';')
        // .find((c: string) => c.trim().startsWith('lang='))

        // const theme = req.headers.cookie
        // .split(';')
        // .find((c: string) => c.trim().startsWith('theme='))

        // if (lang) {
        // this.lang = lang.split('=')[1]

        // }

        // if (theme) {
        //     this.token = theme.split('=')[1]
        // }

        if (!refreshToken) {
          authenticationStore().loggedOut()
          return
        }
        this.refreshToken = refreshToken.split('=')[1]
        if (this.token) {
          this.token = token.split('=')[1]
        }
        this.status = true
      } else {
        this.token = Cookie.get('token')
        this.refreshToken = Cookie.get('refreshToken')
        // this.lang = Cookie.get('lang')
        // this.theme = Cookie.get('theme')
      }
    },

    loggedIn() {
      this.status = true
    },

    loggedOut() {
      try {
        Cookie.remove('token')
        Cookie.remove('refreshToken')
        localStorage.removeItem('userInfo')
        this.status = false
        this.token = ''
        this.refreshToken = ''
        this.user = {}
        // socketUnsubAuth()
      } catch (e) {}
    },

    async submitPhoneRequest(payLoad: object) {
      return api.post('/user/login', payLoad)
    },

    async verifyPhoneRequest(payLoad: object) {
      try {
        const res = await api.post('/user/login/verify', payLoad)
        if (res.data.refreshToken) {
          this.refreshToken = res.data.refreshToken
          this.token = res.data.accessToken
          Cookie.set('refreshToken', this.refreshToken)
          Cookie.set('token', this.token)
        }
        return res
      } catch (error) {
        throw error
      }
    },

    async loginRequest(payLoad: object) {
      try {
        const res = await api.post('account/login', payLoad)
        if (res.data.refreshToken) {
          this.refreshToken = res.data.refreshToken
          this.token = res.data.accessToken
          Cookie.set('refreshToken', this.refreshToken)
          Cookie.set('token', this.token)
        }
        return res
      } catch (error) {
        throw error
      }
    },

    async loginByPasswordRequest(payLoad: object) {
      try {
        const res = await api.post('user/login/password', payLoad)
        if (res.data?.token?.refreshToken) {
          this.refreshToken = res.data.token.refreshToken
          this.token = res.data.token.accessToken
          Cookie.set('refreshToken', this.refreshToken)
          Cookie.set('token', this.token)
        }
        return res
      } catch (error) {
        throw error
      }
    },
    async loginTOTPRequest(payLoad: object) {
      try {
        const res = await api.post('user/login/2fa', payLoad)
        this.refreshToken = res.data.refreshToken
        this.token = res.data.accessToken
        Cookie.set('refreshToken', this.refreshToken)
        Cookie.set('token', this.token)
        return res
      } catch (error) {
        throw error
      }
    },

    async getFreshAccessTokenRequest() {
      try {
        const res = await api.post('token/refresh', {
          refreshToken: this.refreshToken,
        })
        if (res.data.accessToken) {
          this.token = res.data.accessToken
          Cookie.set('token', this.token)
        }
        return res
      } catch (error) {
        throw error
      }
    },

    // set user info

    async setUserInfo() {
      // try {
      //     const res = await api.post('account/refresh', {
      //         refreshToken: this.refreshToken
      //     })
      //     if (res.data.data.refreshToken) {
      //         this.refreshToken = res.data.data.refreshToken
      //         this.token = res.data.data.accessToken
      //         Cookie.set('refreshToken', this.refreshToken)
      //         Cookie.set('token', this.token)
      //     }
      //     return res
      // } catch (error) {
      //     throw error;
      // }
    },
    // forget password

    forgetPasswordSubmitEmailRequest(payLoad: any) {
      return api.post('user/forget-password/send/email', payLoad)
    },
    forgetPasswordVerifyEmailRequest(payLoad: any) {
      return api.post('user/forget-password/verify/email', payLoad)
    },
    forgetPasswordSetPasswordRequest(payLoad: any) {
      return api.patch('user/forget-password', payLoad)
    },
  },
})
