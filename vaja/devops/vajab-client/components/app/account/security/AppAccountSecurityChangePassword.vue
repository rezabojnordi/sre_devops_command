<template>
  <UtilitiesSidePopup
    v-model="value"
    :v-show-mode="true"
    title="تغییر و فعالسازی رمزعبور"
  >
    <div class="column-full-height">
      <div class="mb-2">
        <g-input
          v-model="reset.verificationCode"
          label="کد تایید ارسال شده به ایمیل"
          icon="icon-security-safe"
          type="tel"
          autocomplete="off"
          maxlength="6"
          :error="errors.verificationCode"
        >
          <template #appended>
            <g-btn
              plain
              type="primary"
              class="sm-btn"
              :loading="getCodeLoading"
              @click="getCode()"
              >دریافت کد</g-btn
            >
          </template>
        </g-input>
      </div>

      <div class="mb-2">
        <g-input
          v-model="reset.password"
          label="رمزعبور"
          icon="icon-lock"
          type="password"
          autocomplete="off"
          maxlength="20"
          :error="errors.password"
        />
      </div>
      <div class="mb-2">
        <Field v-slot="{ field }" name="repeatPassword">
          <g-input
            v-model="reset.repeatPassword"
            label="تکرار رمزعبور"
            icon="icon-lock"
            type="password"
            autocomplete="off"
            maxlength="20"
            :error="errors.repeatPassword"
          />
        </Field>
      </div>

      <div class="mb-4">
        <div
          v-for="(item, i) in validatePasswordItems"
          :key="i"
          class="validate-item text-regular-4"
        >
          <span v-if="!item.valid" class="icon-close-circle"></span>
          <span v-else class="icon-check-circle validate-item__checked"></span>
          {{ item.message }}
        </div>
      </div>

      <div class="form-item mt-auto">
        <g-btn :loading="loading" class="w-100" @click="changePasword()"
          >ادامه</g-btn
        >
      </div>
    </div>
  </UtilitiesSidePopup>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { securityStore } from '@/stores/account/security'
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
    const repeatPssword = (value: string): string => {
      return value === Object(this.reset).password
        ? ''
        : 'تکرار رمزعبور با رمزعبور همخوانی ندارد'
    }

    return {
      loading: false,
      getCodeLoading: false,
      validatePasswordItems: [
        {
          message: this.$t('security.validatePassword1'),
          valid: false,
          regex: /^.{8,}$/,
        },
        {
          message: this.$t('security.validatePassword2'),
          valid: false,
          regex: /(?=.*[a-z])(?=.*[A-Z])/,
        },
        {
          message: this.$t('security.validatePassword3'),
          valid: false,
          regex: /\d/,
        },
      ],
      errors: {
        password: '',
        repeatPassword: '',
        verificationCode: '',
      },
      reset: {
        verificationCode: '',
        password: '',
        repeatPassword: '',
        tempToken: '',
      },
      formSchema: {
        verifyCode: (value: string) => {
          return value?.length === 6 ? true : 'لطفا کد 6 رقمی و صحیح وارد کنید'
        },
        password: (value: string) => {
          return value ? true : 'لطفا رمزعبور با مشخصات زیر وارد کنید'
        },
        repeatPassword: repeatPssword,
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
  watch: {
    'reset.password'() {
      let isPasswordValid = true
      this.validatePasswordItems.forEach((item) => {
        item.valid = item.regex.test(this.reset.password)
        if (!item.valid) {
          isPasswordValid = false
        }
      })
      if (isPasswordValid) this.errors.password = ''
    },
    'reset.verificationCode'() {
      if (this.reset.verificationCode.length === 6)
        this.errors.verificationCode = ''
    },
    'reset.repeatPassword'() {
      if (this.reset.repeatPassword === this.reset.password)
        this.errors.repeatPassword = ''
    },
  },
  methods: {
    ...mapActions(securityStore, [
      'getChangePasswordCodeRequest',
      'changePasswordRequest',
    ]),
    async changePasword() {
      let validPassword = true
      this.validatePasswordItems.forEach((item) => {
        if (!item.valid) {
          this.errors.password = 'لطفا رمزعبور قوی تری با شرایط زیر انتخاب کنید'
          validPassword = false
        }
      })
      if (this.reset.verificationCode.length !== 6) {
        this.errors.verificationCode = 'لطفا کد تایید 6رقمی صحیح وارد کنید'
        validPassword = false
      }
      if (this.reset.repeatPassword !== this.reset.password) {
        this.errors.repeatPassword = 'تکرار رمزعبور با رمزعبور همخوانی ندارد'
        validPassword = false
      }
      if (!validPassword) {
        return
      }
      const data = {
        password: this.reset.password,
        otpCode: this.reset.verificationCode,
      }
      try {
        this.loading = true
        await this.changePasswordRequest(data)
        this.$emit('update:modelValue', false)
        this.$toast.success('رمزعبور شما با موفقیت تغییر کرد')
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
    async getCode() {
      try {
        this.getCodeLoading = true
        const res = await this.getChangePasswordCodeRequest()
        this.reset.tempToken = res.data.data.token
        this.reset = {
          verificationCode: '',
          password: '',
          repeatPassword: '',
          tempToken: '',
        }
        this.$toast.success('کد تایید برای ایمیل شما ارسال شد')
        this.getCodeLoading = false
      } catch (error) {
        this.getCodeLoading = false
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
