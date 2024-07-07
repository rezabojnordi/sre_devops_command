<template>
  <div>
    <h1 class="text-title-3">تغییر رمزعبور</h1>

    <div class="auth-under-title mb-3">
      <div class="auth-under-title__text">رمزعبور جدید خود را وارد کنید</div>
    </div>

    <div class="attention-text mb-3">
      توجه داشته باشید که درصورت تغییر رمز، جهت حفظ امنیت حساب کاربری شما تا ۲۴
      ساعت امکان برداشت از حساب بسته خواهد شد.
    </div>

    <Form @submit="chnagePassword()">
      <g-input
        v-model="reset.password"
        label="رمزعبور جدید"
        icon="icon-lock-dots"
        maxlength="50"
        type="password"
        input-id="password"
        autocompelete="off"
        :error="errors.password"
      />
      <g-input
        v-model="reset.repeatPassword"
        label="رمزعبور جدید"
        icon="icon-lock-dots"
        maxlength="50"
        type="password"
        input-id="newPassword"
        autocompelete="off"
        :error="errors.repeatPassword"
      />
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

      <div class="form-item">
        <g-btn class="w-100">تغییر رمز عبور</g-btn>
      </div>
    </Form>
    <div class="mt-3 text-center">
      <button class="text-btn" @click="$emit('cancel')">انصراف</button>
    </div>
  </div>
</template>

<script lang="ts">
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
      loading: false,
      successDialog: false,
      password: '',
      repeatPassword: '',
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
        password: '',
        repeatPassword: '',
      },
    }
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
    'reset.repeatPassword'() {
      if (this.reset.repeatPassword === this.reset.password)
        this.errors.repeatPassword = ''
    },
  },
  methods: {
    ...mapActions(authenticationStore, ['forgetPasswordSetPasswordRequest']),
    async chnagePassword() {
      let validPassword = true
      this.validatePasswordItems.forEach((item) => {
        if (!item.valid) {
          this.errors.password = 'لطفا رمزعبور قوی تری با شرایط زیر انتخاب کنید'
          validPassword = false
        }
      })
      if (this.reset.repeatPassword !== this.reset.password) {
        this.errors.repeatPassword = 'تکرار رمزعبور با رمزعبور همخوانی ندارد'
        validPassword = false
      }
      if (!validPassword) {
        return
      }
      const data = {
        email: this.email,
        password: this.reset.password,
        otpToken: this.token,
      }
      try {
        this.loading = true
        await this.forgetPasswordSetPasswordRequest(data)
        this.$router.push('/login')
        alert('رمزعبور شما با موفقیت عوض شد')
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.text-btn {
  font-size: 0.9rem;
  color: $--color-neutral-300;
  border: 0;
  background-color: transparent;
  cursor: pointer;
}
</style>
