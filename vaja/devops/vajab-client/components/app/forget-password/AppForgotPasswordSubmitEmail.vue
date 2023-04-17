<template>
  <div>
    <h1 class="text-title-3">ایمیل خود را وارد کنید</h1>

    <div class="auth-under-title">
      <div class="auth-under-title__text">
        لطفا ایمیل خود را به صورت صحیح در کادر زیر وارد کنید
      </div>
    </div>
    <Form
      v-slot="{ errors }"
      :validation-schema="formSchema"
      @submit="submitEmail()"
    >
      <div class="form-item">
        <Field v-slot="{ field }" name="email">
          <g-input
            v-model="email"
            label="ایمیل شما"
            icon="icon-sms"
            maxlength="100"
            type="email"
            name="email"
            :error="errors.email"
            v-bind="field"
          />
        </Field>
      </div>
      <div class="form-item">
        <g-btn class="w-100" :loading="loading">تایید</g-btn>
      </div>
    </Form>
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { authenticationStore } from '@/stores/authentication'

export default {
  data() {
    return {
      loading: false,
      email: '',
      formSchema: {
        email: 'email',
      },
    }
  },
  methods: {
    ...mapActions(authenticationStore, ['forgetPasswordSubmitEmailRequest']),
    async submitEmail() {
      const data = {
        email: this.email,
      }
      try {
        this.loading = true
        const res = await this.forgetPasswordSubmitEmailRequest(data)
        this.$emit('submit', {
          ...res,
          email: this.email,
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
