import { defineStore } from 'pinia'
import lodash from 'lodash'

export const appStore = defineStore('app', {
  state: () => ({
    user: 'درود بر رزمندگان اسلام',
    drawer: true,
  }),

  getters: {
    isLoggedIn: (state) => state.user,
  },

  actions: {
    handleError: lodash.debounce(function (error: any) {
      if (!error.response) {
        alert('اتصال خود را بررسی کنید')
      } else if (error.response.status === 401 && error.method !== 'login') {
        alert('لطفا وارد سیستم  شوید')
        //   this.$router.push({
        //     path: '/'
        //   })
      } else if (error.response.status >= 500) {
        alert('سیستم با خطا مواجه شد!')
      } else if (error.response?.data?.error) {
        alert(error.response.data.error)
      }
    }, 500),
  },
})
