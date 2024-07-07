<template>
  <div>
    <h1 class="text-title-3">کد ایمیل</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        کد 6 رقمی ارسال شده به ایمیل
        <b class="color-primary">{{ email }}</b>
        را وارد کنید
      </div>
      <div class="link-action" @click="$emit('toPrev')">ویرایش ایمیل</div>
    </div>

    <Form @submit="verifyEmail()">
      <div class="form-item">
        <g-input
          v-model="verificationCode"
          label="کد 6 رقمی"
          icon="icon-note"
          maxlength="6"
          type="tel"
          autocomplete="off"
        />
      </div>
      <div class="form-item">
        <g-btn
          class="w-100"
          :loading="loading"
          :disaled="verificationCode.length !== 6"
          >تایید</g-btn
        >
      </div>
    </Form>

    <utilities-count-down
      v-if="resendDuration !== 0"
      v-slot="{ time }"
      v-model:duration="resendDuration"
      :custom="true"
    >
      <div class="text-center mt-2">
        ارسال مجدد کد تا
        <span class="time-resend">{{ time }}</span>
        ثانیه دیگر
      </div>
    </utilities-count-down>
    <div v-else class="mt-3 text-center">
      <span class="link-action" @click="submitEmail()"> ارسال مجدد کد </span>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'
export default {
  props: {
    email: {
      type: String,
      required: true,
      default: '',
    },
    token: {
      type: String,
      required: true,
      default: '',
    },
  },
  data() {
    return {
      verificationCode: '',
      tempToken: '',
      resendDuration: 60,
    }
  },
  created() {
    this.tempToken = this.token
  },
  methods: {
    ...mapActions(authenticationStore, [
      'forgetPasswordSubmitEmailRequest',
      'forgetPasswordVerifyEmailRequest',
    ]),
    async submitEmail() {
      const data = {
        email: this.email,
      }
      try {
        this.loading = true
        const res = await this.forgetPasswordSubmitEmailRequest(data)
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
    async verifyEmail() {
      const data = {
        email: this.email,
        otpCode: this.verificationCode,
      }
      try {
        this.loading = true
        const res = await this.forgetPasswordVerifyEmailRequest(data)
        this.$emit('submit', res.data.token)
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped></style>
