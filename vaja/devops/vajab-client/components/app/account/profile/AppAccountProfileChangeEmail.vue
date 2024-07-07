<template>
  <UtilitiesSidePopup
    v-model="value"
    :v-show-mode="true"
    title="ثبت و تغییر ایمیل"
  >
    <div>
      <div v-if="step === 1">
        <g-input
          v-model="mobileVerificationCode"
          label="کد تایید 6رقمی ارسال شده به موبایل"
          icon="icon-security-safe"
          type="tel"
          autocomplete="off"
          maxlength="6"
          @input.enter="verifyMobile()"
        >
          <template #appended>
            <g-btn
              plain
              type="primary"
              class="sm-btn"
              :loading="getCodeLoading"
              @click.prevent="getCode()"
              >دریافت کد</g-btn
            >
          </template>
        </g-input>

        <div class="form-item mt-auto">
          <g-btn
            :loading="loading"
            :disabled="mobileVerificationCode.length !== 6"
            class="w-100"
            @click="verifyMobile()"
            >ادامه</g-btn
          >
        </div>
      </div>
      <Form
        v-if="step === 2"
        v-slot="{ errors }"
        :validation-schema="step1Schema"
        @submit="submitEmail()"
      >
        <Field v-slot="{ field }" name="email">
          <div class="text-regular-5 text-light mb-4">
            لطفا ایمیل خود را به صورت صحیح در کادر زیر وارد نمایید.
          </div>
          <div class="mb-2">
            <g-input
              v-model="email"
              label="ایمیل شما"
              icon="icon-sms"
              type="email"
              name="email"
              input-id="email"
              maxlength="100"
              v-bind="field"
              :error="errors.email"
            />
          </div>
        </Field>

        <div class="form-item mt-auto">
          <g-btn :loading="loading" class="w-100">ادامه</g-btn>
        </div>
      </Form>

      <!-- verify email form (step 2) -->
      <Form
        v-else-if="step === 3"
        v-slot="{ errors }"
        :validation-schema="step2Schema"
        @submit="verifyEmail()"
      >
        <div class="text-regular-5 text-light mb-4">
          کد ۶ رقمی ارسال شده به ایمیل
          <b class="color-primary">moein@gmail.com</b>
          را وارد کنید
        </div>
        <Field v-slot="{ field }" name="verificationCode">
          <div class="mb-2">
            <g-input
              v-model="emailVerificationCode"
              label="کد ایمیل شده"
              icon="icon-note-2"
              type="text"
              maxlength="6"
              autocomplete="off"
              v-bind="field"
              :error="errors.verificationCode"
            />
          </div>
        </Field>

        <div class="form-item mt-auto">
          <g-btn
            :loading="loading"
            :disabled="emailVerificationCode.length !== 6"
            class="w-100"
            >ادامه</g-btn
          >
        </div>

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
          <div
            v-else
            class="text-center link-action mt-2"
            @click="submitEmail()"
          >
            ارسال مجدد کد
          </div>
        </div>
      </Form>
    </div>
  </UtilitiesSidePopup>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { profileStore } from '@/stores/account/profile'

export default {
  props: {
    modelValue: {
      type: Boolean,
      default: false,
      rquire: true,
    },
  },
  emits: ['update:modelValue'],
  data() {
    return {
      loading: false,
      getCodeLoading: false,
      mobileVerificationCode: '',
      emailVerificationCode: '',
      otpToken: '',
      resendLoading: false,
      step: 1,
      email: '',
      verificationCode: '',
      resendDuration: 60,
      step1Schema: {
        email: 'email',
      },
      step2Schema: {
        verificationCode: (value: string) => {
          return value?.length === 6 ? true : 'لطفا کد 6 رقمی و صحیح وارد کنید'
        },
      },
    }
  },
  computed: {
    value: {
      get() {
        return this.modelValue
      },
      set(newValue: boolean) {
        this.$emit('update:modelValue', newValue)
      },
    },
  },
  methods: {
    ...mapActions(profileStore, [
      'changeEmailSubmitRequest',
      'changeEmailVerifyRequest',
      'changeEmailGetMobileCodeRequest',
      'changeEmailVerifyMobileCodeRequest',
    ]),
    async submitEmail() {
      this.step = 2
      const data = {
        email: this.email,
      }
      try {
        this.loading = true
        this.resendLoading = true
        await this.changeEmailSubmitRequest(data)
        this.$toast.success('کد برای ایمیل شما ارسال شد')
        this.step = 3
        this.resendDuration = 60
        this.loading = false
        this.resendLoading = false
      } catch (error) {
        this.loading = false
        this.resendLoading = false
      }
    },
    async getCode() {
      try {
        this.getCodeLoading = true
        await this.changeEmailGetMobileCodeRequest()
        this.$toast.success('کد برای موبایل شما ارسال شد')
        this.getCodeLoading = false
      } catch (error) {
        this.getCodeLoading = false
      }
    },
    async verifyMobile() {
      const data = {
        otpCode: this.mobileVerificationCode,
      }

      try {
        this.loading = true
        const res = await this.changeEmailVerifyMobileCodeRequest(data)
        this.otpToken = res.data.token
        this.step = 2
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
    async verifyEmail() {
      const data = {
        email: this.email,
        otpCode: this.emailVerificationCode,
        otpToken: this.otpToken,
      }

      try {
        this.loading = true
        await this.changeEmailVerifyRequest(data)
        this.$toast.success('ایمیل با موفقیت ثبت شد')
        this.$emit('update:modelValue', false)
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss">
.sm-btn {
  padding: 0.3rem 0.5rem;
  min-width: auto;
  font-size: 0.7rem;
  margin-left: -0.5rem;
}

.column-full-height {
  display: flex;
  flex-direction: column;
  height: 100%;
}
</style>
