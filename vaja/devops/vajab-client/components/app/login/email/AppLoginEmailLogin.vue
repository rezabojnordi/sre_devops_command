<template>
  <div>
    <h1 class="text-title-3">ورود/عضویت</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        برای ورود لطفا ایمیل و رمزعبور خود را وارد نمایید
      </div>
      <div class="auth-under-title__action" @click="$emit('toOtp')">
        ورود با اس ام اس
      </div>
    </div>

    <Form v-slot="{ errors }" :validation-schema="formSchema" @submit="login()">
      <div class="form-item">
        <Field v-slot="{ field }" name="username">
          <g-input
            v-bind="field"
            v-model="auth.email"
            label="ایمیل خود را وارد نمایید"
            icon="icon-mobile"
            maxlength="100"
            type="email"
            input-id="username"
            name="username"
            :error="errors.username"
          />
        </Field>
      </div>
      <div class="form-item">
        <Field v-slot="{ field }" name="password">
          <g-input
            v-bind="field"
            v-model="auth.password"
            label="رمزعبور خود را وارد کنید"
            icon="icon-lock-dots"
            maxlength="50"
            type="password"
            input-id="password"
            name="password"
            :error="errors.password"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn :loading="loading" class="w-100">ادامه</g-btn>
      </div>
    </Form>
    <div class="text-center mt-2">
      <router-link to="/forget-password" class="text-light text-regular-5">
        رمز عبور را فراموش کرده ام
      </router-link>
    </div>
    <action-dialog v-model="dialog" action-text="متوجه شدم" type="failed" />
  </div>
</template>

<script>
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'
export default {
  data() {
    return {
      dialog: false,
      loading: false,
      auth: {
        email: '',
        password: '',
      },
      formSchema: {
        username: 'email',
        password: 'required',
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, ['loginByPasswordRequest']),
    async login() {
      const data = {
        email: this.auth.email,
        password: this.auth.password,
      }
      try {
        this.loading = true
        const res = await this.loginByPasswordRequest(data)
        this.$emit('submit', {
          ...res.data,
          email: this.auth.email,
        })
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.red {
  color: $--color-primary;
}

.accept-text {
  margin-top: 0.4rem;
  color: $--color-neutral-700;
  font-size: 10px;
  text-align: center;
}
</style>
