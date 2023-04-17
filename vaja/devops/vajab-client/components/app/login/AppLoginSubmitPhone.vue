<template>
  <div>
    <h1 class="text-title-3">ورود/عضویت</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        توجه داشته باشید که
        <span class="color-primary">شماره موبایل به نام خودتان</span>
        باشد!
      </div>
      <div
        class="auth-under-title__action"
        @click="$emit('changeLoginType', 'email')"
      >
        ورود با ایمیل و رمزعبور
      </div>
    </div>

    <Form
      v-slot="{ errors }"
      :validation-schema="formSchema"
      @submit="submitPhone()"
    >
      <div class="form-item">
        <Field v-slot="{ field }" name="phone">
          <g-input
            v-model="phoneNumber"
            label="تلفن همراه"
            icon="icon-mobile"
            maxlength="11"
            type="tel"
            name="phone"
            input-id="phone"
            :error="errors.phone"
            v-bind="field"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn :loading="loading" class="w-100">ادامه</g-btn>
      </div>
    </Form>
    <div class="text-center accept-text text-regular-6 mt-2">
      با ثبت و رد کردن این مرحله
      <router-link to="/policies">شرایط و قوانین وجب</router-link>
      را میپذیرم
    </div>
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'
export default {
  data() {
    return {
      loading: false,
      phoneNumber: '',
      formSchema: {
        phone: 'phone',
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, ['submitPhoneRequest']),
    async submitPhone() {
      const data = {
        mobile: this.phoneNumber,
      }
      try {
        this.loading = true
        const res = await this.submitPhoneRequest(data)
        this.$emit('submit', {
          ...res.data,
          phoneNumber: this.phoneNumber,
        })
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped></style>
