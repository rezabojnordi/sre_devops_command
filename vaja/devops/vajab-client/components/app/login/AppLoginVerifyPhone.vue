<template>
  <div>
    <h1 class="text-title-3">تایید شماره موبایل</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        کد به شماره موبایل
        <b class="color-primary">{{ phoneNumber }}</b>
        ارسال شد
      </div>
      <div class="link-action" @click="$emit('editPhone')">ویرایش شماره</div>
    </div>
    <Form v-slot="{ errors }" :validation-schema="formSchema" @submit="login()">
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
          @click="submitPhone('otpCode')"
        >
          ارسال مجدد پیامک
        </div>
        <div
          class="auth-bottom-actions__action link-action"
          @click="submitPhone('otpVoice')"
        >
          تماس تلفنی
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
    phoneNumber: {
      type: String,
      default: '',
      required: true,
    },
  },
  emits: ['submit'],
  data() {
    return {
      resendDuration: 60,
      loading: false,
      resendLoading: false,
      verificationCode: '',
      formSchema: {
        verificationCode: (value: string) => {
          return value?.length === 6 ? true : 'لطفا کد 6 رقمی و صحیح وارد کنید'
        },
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, [
      'verifyPhoneRequest',
      'submitPhoneRequest',
    ]),

    async submitPhone(otpType: string) {
      if (this.resendLoading) {
        return
      }
      const data = {
        mobile: this.phoneNumber,
      }
      try {
        this.resendLoading = true
        await this.submitPhoneRequest(data)
        alert('کد تایید ارسال شد')
        this.resendDuration = 60
        this.resendLoading = false
      } catch (error) {
        this.resendLoading = false
      }
    },

    async login() {
      const data = {
        mobile: this.phoneNumber,
        otpCode: this.verificationCode,
      }
      try {
        this.loading = true
        const res = await this.verifyPhoneRequest(data)
        this.$emit('submit', res?.data)
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
      border-right: 2px solid #ededed;
    }
  }
}
</style>
