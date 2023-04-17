import { defineStore } from 'pinia'
import { api } from '@/services/axios'

export const profileStore = defineStore('profile', {
  actions: {
    changeEmailSubmitRequest(payLoad: any) {
      return api.post('user/change-email/send/email', payLoad)
    },
    changeEmailVerifyRequest(payLoad: any) {
      return api.patch('user/change-email', payLoad)
    },
    changeEmailGetMobileCodeRequest() {
      return api.post('user/change-email/send/mobile')
    },
    changeEmailVerifyMobileCodeRequest(payLoad: any) {
      return api.post('user/change-email/verify/mobile', payLoad)
    },
  },
})
