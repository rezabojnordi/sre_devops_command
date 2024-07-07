<template>
  <div>
    <h1 class="text-title-3">رمزعبور خود را وارد کنید</h1>

    <Form
      v-slot="{ errors }"
      :validation-schema="formSchema"
      @submit="loginByPassword()"
    >
      <div class="form-item">
        <Field v-slot="{ field }" name="password">
          <g-input
            v-model="password"
            label="رمزعبور"
            icon="icon-lock-dots"
            maxlength="100"
            type="password"
            :error="errors.password"
            v-bind="field"
            autocomplete="off"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn class="w-100" :loading="loading">ارسال</g-btn>
      </div>
    </Form>
    <div class="text-center mt-2">
      <router-link to="/forget-password" class="text-light text-regular-5">
        رمز عبور را فراموش کرده ام
      </router-link>
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
  data() {
    return {
      loading: false,
      password: '',
      formSchema: {
        password: (value: string) => {
          return value?.length ? true : 'وارد کردن رمزعبور الزامی است'
        },
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, ['loginByPasswordRequest']),
    async loginByPassword() {
      const data = {
        mobile: this.phoneNumber,
        password: this.password,
      }
      try {
        this.loading = true
        const res = await this.loginByPasswordRequest(data)
        if (res.data?.token?.accessToken) {
          this.$router.push('/account')
        } else {
          this.$emit('submit', res?.data)
        }
        this.loading = false
      } catch (error) {
        console.log(error)
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
