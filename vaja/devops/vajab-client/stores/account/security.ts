import { defineStore } from 'pinia'
import { api } from '@/services/axios'

export const securityStore = defineStore('security', {
  actions: {
    GAetMobileVerificationCodeRequest() {
      return api.post('user/enable-totp/send/mobile')
    },
    GAVerifyMobileRequest(payLoad: object) {
      return api.post('user/enable-totp/verify/mobile', payLoad)
    },
    GAEnableRequest(payLoad: object) {
      return api.post('user/enable-totp', payLoad)
    },
    enableGARequest(payLoad: object) {
      return api.patch('user/enable-totp', payLoad)
    },
    disableGARequest(payLoad: object) {
      return api.post('account/twoStep/disable', payLoad)
    },
    getActiveSessionsHistory() {
      return api.get('account/sessions')
    },
    removeSessionItem(payLoad: any) {
      return api.delete(
        `account/session/terminate?sessionId=${payLoad.sessionId}`
      )
    },
    getChangePasswordCodeRequest() {
      return api.post('user/change-password/send/email')
    },
    changePasswordRequest(payLoad: object) {
      return api.patch('user/change-password', payLoad)
    },
  },
})
