<template>
  <div class="security-page">
    <g-row :gutter="0">
      <g-col flex-1>
        <div class="account-action-item">
          <div class="account-action-item__info">
            <div class="account-action-item__icon">
              <span class="icon-password-check"></span>
            </div>
            <div class="account-action-item__texts">
              <div class="text-sm-2">تعیین و تغییر رمز عبور</div>
              <div class="text-regular-4 account-action-item__des">
                برای مدیریت رمز ورود به سیستم استفاده م ی شود
              </div>
            </div>
          </div>
          <div>
            <g-btn
              type="primary"
              plain
              class="account-action-item__button w-100"
              @click="changePasswordDialog = true"
              >تغییر</g-btn
            >
          </div>
        </div>

        <div class="account-action-item">
          <div class="account-action-item__info">
            <div class="account-action-item__icon">
              <span class="icon-google"></span>
            </div>
            <div class="account-action-item__texts">
              <div class="text-sm-2">
                شناسه دوعاملی ( Google Authenticator )
              </div>
              <div class="text-regular-4 account-action-item__des">
                افزودن ایمیل تأیید برداشت برای مدیریت مشترک حساب
              </div>
            </div>
          </div>
          <div>
            <g-btn
              type="primary"
              plain
              class="account-action-item__button w-100"
              :loading="loading"
              @click="GADialog = true"
              >فعال سازی</g-btn
            >
          </div>
        </div>
      </g-col>
      <g-col class="account--security-vector">
        <img
          src="@/assets/images/account/security-vector.svg"
          alt="security page vector"
        />
      </g-col>
    </g-row>

    <UtilitiesSidePopup v-model="GADialog" title="فعال سازی شناسه دوعاملی">
      <div class="text-regular-3 text-center">
        <div v-if="step === 1">
          <g-input
            v-model="verificationCode"
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
                @click.prevent="getMobileVerificationCode()"
                >دریافت کد</g-btn
              >
            </template>
          </g-input>
          <div class="form-item">
            <g-btn
              class="w-100"
              :loading="actionLoading"
              :disabled="verificationCode.length !== 6"
              @click="verifyMobile()"
              >ادامه</g-btn
            >
          </div>
        </div>
        <div v-if="step === 2">
          کد QR زیر را در اپلیکیشن Google Authenticator اسکن کنید
          <g-qrcode style="margin: 1.7rem auto 2rem auto" :value="totpUri" />

          <div class="divider"></div>

          <g-input
            v-model="totpSecret"
            label="کد بازیابی"
            icon="icon-key-square"
            type="text"
            readonly
            top-label
            no-error
          />

          <div class="ga-attention">
            <span class="icon-info-circle ga-attention__icon"></span>
            <div class="ga-attention__text text-regular-5">
              حتما این کد رو در جایی امن ذخیره سازی کنید.
            </div>
          </div>

          <div class="attention-warning">
            <div class="text-regular-4">
              کاربر گرامی لطفا کدبازیابی بالا را در مکانی امن ذخیره کنید, تا در
              صورت در دسترس نبودن اپ google authenticator امکان بازیابی کد دو
              عاملی را داشته باشید
            </div>
          </div>

          <Form @submit="submitGACode()">
            <g-input
              v-model="GAVerifyCode"
              label="کد تایید دومرحله ای"
              placeholder="کد شناسایی 2 عاملی خود را وارد کنید"
              icon="icon-security-safe"
              type="tel"
              autocomplete="off"
              maxlength="6"
              :top-label="true"
            />
            <div class="form-item">
              <g-btn
                :loading="actionLoading"
                :disabled="GAVerifyCode.length !== 6 && otpCode.length !== 6"
                class="w-100"
                >ادامه</g-btn
              >
            </div>
          </Form>
        </div>
      </div>
    </UtilitiesSidePopup>
    <app-account-security-change-password v-model="changePasswordDialog" />
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { securityStore } from '@/stores/account/security'
import { string } from 'yup'

export default {
  data() {
    return {
      step: 1,
      changePasswordDialog: false,
      getCodeLoading: false,
      verificationCode: '',
      GADialog: false,
      GAToken: '',
      GAVerifyCode: '',
      otpCode: '',
      loading: false,
      actionLoading: false,
      iv: '',
      totpSecret: '',
      totpUri: '',
    }
  },
  watch: {
    GAVerifyCode() {
      if (this.GAVerifyCode.length === 6) {
        this.submitGACode()
      }
    },
  },
  methods: {
    ...mapActions(securityStore, [
      'GAetMobileVerificationCodeRequest',
      'GAEnableRequest',
      'GAVerifyMobileRequest',
      'enableGARequest',
    ]),
    async getMobileVerificationCode() {
      try {
        this.getCodeLoading = true
        const response = await this.GAetMobileVerificationCodeRequest()
        this.getCodeLoading = false
        this.$toast.success('کد برای موبایل شما ارسال شد')
      } catch (error) {
        this.getCodeLoading = false
      }
    },
    async verifyMobile() {
      try {
        const data = {
          otpCode: this.verificationCode,
        }
        this.actionLoading = true
        const res = await this.GAVerifyMobileRequest(data)
        this.iv = res.data.iv
        this.totpSecret = res.data.totpSecret
        this.totpUri = res.data.totpUri
        this.actionLoading = false
        this.step = 2
      } catch (error) {
        this.actionLoading = false
      }
    },
    async submitGACode() {
      try {
        this.actionLoading = true
        const data = {
          otpCode: this.GAVerifyCode,
          totpSecret: this.totpSecret,
          iv: this.iv,
        }
        await this.enableGARequest(data)
        this.GADialog = false
        this.actionLoading = false
        this.$toast.success('شناسه دوعاملی GA با موفقیت برای شما فعال شد')
      } catch (error) {
        console.log(error)
        this.actionLoading = false
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.security-page {
  padding-bottom: 5rem;
}
.account--security-vector {
  margin: 5rem 5rem 0 1.5rem;
  img {
    width: 19.75rem;
  }
}
.account-action-item {
  margin-top: 1.5rem;
  padding: 1rem 1.3rem;
  border: 1px solid $--border-color-2;
  border-radius: $--border-radius-base;
  display: flex;
  align-items: center;
  justify-content: space-between;
  &__info {
    display: flex;
    align-items: center;
  }
  &__icon {
    width: 2.8rem;
    height: 2.8rem;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: $--color-primary-50;
    color: $--color-primary;
    border-radius: 100%;
  }
  &__texts {
    flex: 1;
    margin: 0 1rem;
  }
  &__des {
    color: $--color-neutral-300;
    margin-top: 0.2rem;
  }
  &__button {
    width: 100px;
  }
}

.ga-attention {
  display: flex;
  align-items: center;
  margin-top: 0.625rem;
  &__icon {
    color: $--color-warning-300;
  }
  &__text {
    margin: 0 0.25rem;
    color: $--color-neutral-300;
  }
}

.attention-warning {
  padding: 1.2rem 1.5rem;
  margin: 1rem 0;
  background-color: $--color-warning-50;
  color: $--color-warning-300;
  text-align: justify;
  border-radius: $--border-radius-base;
  &__title {
    margin-bottom: 0.8rem;
  }
}

.divider {
  border-bottom: 1px solid $--border-color-2;
  margin: 1.8rem 0;
}
</style>
