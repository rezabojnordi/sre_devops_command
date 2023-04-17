<template>
  <div>
    <app-forgot-password-submit-email
      v-if="step === 1"
      @submit="emailSubmitted"
    />
    <app-forgot-password-verify-email
      v-if="step === 2"
      :email="email"
      :token="token"
      @to-next="step = 3"
      @submit="emailVerified"
      @to-prev="step = 1"
    />
    <app-forgot-password-change-password
      v-if="step === 3"
      :email="email"
      :token="step2Token"
      @cancel="step = 1"
    />
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'auth',
})

const step = ref<number>(1)
const token = ref<string>('')
const email = ref<string>('')
const step2Token = ref<string>('')

const emailSubmitted = (data: any) => {
  email.value = data.email
  step.value = 2
}
const emailVerified = (token: string) => {
  step2Token.value = token
  step.value = 3
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
