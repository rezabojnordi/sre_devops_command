<template>
  <div>
    <h1 class="text-title-3">تایید ایمیل</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        کد به ایمیل
        <b class="color-primary">{{ email }}</b>
        ارسال شد
      </div>
      <div class="link-action text-light" @click="$emit('editEamil')">
        بازگشت
      </div>
    </div>
    <Form
      v-slot="{ errors }"
      :validation-schema="formSchema"
      @submit="verifyEmail()"
    >
      <div class="form-item">
        <Field v-slot="{ field }" name="verificationCode">
          <g-input
            v-model="verificationCode"
            label="کد ارسال شده را وارد کنید"
            icon="icon-note"
            maxlength="6"
            type="tel"
            :error="errors.verificationCode"
            v-bind="field"
            autocomplete="off"
            :disabled="verificationCode.length !== 6"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn class="w-100" :loading="loading">ارسال</g-btn>
      </div>
    </Form>
    <div class="auth-bottom-actions">
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
      <div v-else class="auth-bottom-actions__actions">
        <div
          class="auth-bottom-actions__action link-action"
          @click="submitEmail()"
        >
          ارسال مجدد کد
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'

export default {
  name: 'SubmitPhone',
  props: {
    token: {
      type: String,
      default: '',
      required: true,
    },
    email: {
      type: String,
      default: '',
      required: true,
    },
    password: {
      type: String,
      default: '',
      required: true,
    },
  },
  data() {
    return {
      resendDuration: 60,
      loading: false,
      resendLoading: false,
      tempToken: '',
      verificationCode: '',
      formSchema: {
        verificationCode: (value: string) => {
          return value?.length === 6 ? true : 'لطفا کد 6 رقمی و صحیح وارد کنید'
        },
      },
    }
  },
  created() {
    this.tempToken = this.token
  },
  methods: {
    ...mapActions(authenticationStore, ['loginRequest', 'submitPhoneRequest']),
    async submitEmail() {
      if (this.resendLoading) {
        return
      }
      const data = {
        email: this.email,
        loginType: 'password',
        password: this.password,
      }
      try {
        this.resendLoading = true
        const res = await this.loginRequest(data)
        this.tempToken = res?.data.data.token
        alert('کد تایید ارسال شد')
        this.resendDuration = 60
        this.resendLoading = false
      } catch (error) {
        this.resendLoading = false
      }
    },

    async verifyEmail() {
      const data = {
        email: this.email,
        loginType: 'twoStep',
        loginTempToken: this.tempToken,
        password: this.verificationCode,
      }
      try {
        this.loading = true
        await this.loginRequest(data)
        this.$router.push('/account')
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.auth-bottom-actions {
  margin-top: 15px;
  min-height: 1.2rem;
  &__actions {
    display: flex;
    align-items: center;
    justify-content: center;
  }
  &__action {
    padding: 0 18px;
    line-height: 16px;
    &:last-of-type {
      border-right: none;
    }
  }
}
</style>
