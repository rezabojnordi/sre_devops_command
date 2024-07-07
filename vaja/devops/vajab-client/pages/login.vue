<template>
  <div v-if="loginType === 'otp'">
    <div v-if="step === 1">
      <app-login-submit-phone
        @submit="phoneSubmited"
        @change-login-type="loginType = 'email'"
      />
    </div>
    <div v-else-if="step === 2">
      <app-login-verify-phone
        v-if="step1Type == 1"
        :phone-number="phoneNumber"
        @edit-phone="editPhoto"
        @submit="handleLogin"
      />
      <app-login-submit-password
        v-else-if="step1Type == 2"
        :phone-number="phoneNumber"
        @submit="handleLogin"
      />
    </div>
  </div>
  <div v-else-if="loginType === 'email'">
    <app-login-email-login
      v-if="step === 1"
      @to-otp="loginType = 'otp'"
      @submit="handleLogin"
    />
  </div>
  <div v-else-if="loginType === 'totp'">
    <app-login-submit-totp
      :login-temp-token="loginTempToken"
      :phone="phoneNumber"
      :email="email"
      @submit="handleLogin"
    />
  </div>
</template>

<script lang="ts">
definePageMeta({
  layout: 'auth',
})

export default {
  name: 'Login',
  layout: 'auth',
  data() {
    return {
      loginType: 'otp',
      step1Type: 1,
      step: 1,
      newUser: false,
      loading: false,
      phoneNumber: '',
      email: '',
      password: '',
      loginTempToken: '',
    }
  },
  methods: {
    editPhoto() {
      this.phoneNumber = ''
      this.step = 1
    },
    phoneSubmited(data: any) {
      this.phoneNumber = data.phoneNumber
      if (data.flgPassword) {
        this.step1Type = 2
      } else {
        this.step1Type = 1
      }
      if (data.register) {
        this.newUser = true
      }
      this.step = 2
    },
    handleLogin(data: any) {
      if (data.accessToken) {
        this.$router.push('/account')
        return
      }

      if (data.email) {
        this.email = data.email
      }

      if (data.flgTotp) {
        this.loginType = 'totp'
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.accept-text {
  margin-top: 0.4rem;
  color: $--color-neutral-700;
  font-size: 10px;
  text-align: center;
}
</style>
