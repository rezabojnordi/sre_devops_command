<template>
  <div>
    <h1 class="text-title-3">کد شناسایی ۲ عاملی</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        کد شناسایی ۲عاملی ارسال شده از طریق نرم افزار Authenticator را در کادر
        زیر وارد کنید
      </div>
    </div>
    <Form v-slot="{ errors }" :validation-schema="formSchema" @submit="login()">
      <div class="form-item">
        <Field v-slot="{ field }" name="verificationCode">
          <g-input
            v-model="verificationCode"
            label="کد شناسایی 2عاملی"
            icon="icon-note"
            maxlength="6"
            type="tel"
            :error="errors.verificationCode"
            v-bind="field"
            autocomplete="off"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn
          class="w-100"
          :disabled="verificationCode.length !== 6"
          :loading="loading"
          >ارسال</g-btn
        >
      </div>
    </Form>
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'

export default {
  name: 'Submit2fa',
  props: {
    loginTempToken: {
      type: String,
      require: true,
      default: '',
    },
    phone: {
      type: String,
      require: undefined,
      default: '',
    },
    email: {
      type: String,
      require: undefined,
      default: '',
    },
  },
  data() {
    return {
      loading: false,
      verificationCode: '',
      formSchema: {
        verificationCode: (value: string) => {
          return value?.length === 6
            ? true
            : 'لطفا کد 2عاملی معتبر و 6 رقمی وارد کنید'
        },
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, ['loginTOTPRequest']),
    async login() {
      const data = {
        otpCode: this.verificationCode,
        email: this.email ? this.email : undefined,
        mobile: this.phone ? this.phone : undefined,
      }
      try {
        this.loading = true
        const res = await this.loginTOTPRequest(data)
        this.$emit('submit', res.data)
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>
