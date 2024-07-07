<template>
  <div>
    <AppAccountCard icon="icon-user-edit" :has-help="false">
      <template #customHead>
        <div class="kyc-head">
          <div class="choose-group-title">
            <div>
              <span class="icon-mouse-square"></span>
              <b> {{ $t('kyc.accountType') }}: </b>
            </div>
            <UtilitiesButtonGroup v-model="selectedTab" :items="tabs" />
          </div>
          <div class="kyc-head__phone">
            <span>احراز هویت برای شماره: </span>
            <!-- user register phoneNum -->
            <b>09370731087</b>
          </div>
        </div>
      </template>
      <app-account-kyc-stepper :steps="steps" />
      <div class="mt-4 pt-3">
        <app-account-kyc-step-1 v-if="step === 1" />
        <app-account-kyc-step-2 v-else-if="step === 2" />
        <app-account-kyc-step-3 v-else-if="step === 3" />
      </div>
    </AppAccountCard>

    <g-dialog v-model="firstInitDialog" :max-width="546">
      <div class="kyc-steps">
        <div class="kyc-steps__header">
          <div class="g-row">
            <span class="icon-info-circle kyc-steps__icon"></span>
            <div class="kyc-steps__title text-sm-1 flex-1">
              برای استفاده نامحدود از تمام خدمات وجب لطفا حساب کاربری خودرا
              تکمیل کنید.
            </div>
          </div>
        </div>
        <div class="kyc-steps__body">
          <g-row :gutter="22">
            <g-col>
              <app-account-kyc-kyc-wizard :steps="wizardSteps" />
            </g-col>
            <g-col flex-1>
              <div v-for="step in wizardSteps" class="kyc-steps__item">
                <div class="text-sm-1">{{ step.title }}</div>
                <div class="kyc-steps__item-des text-regular-4">
                  {{ step.des }}
                </div>
              </div>
            </g-col>
          </g-row>
          <g-btn class="w-100 mt-4" @click="firstInitDialog = false"
            >شروع</g-btn
          >
        </div>
      </div>
    </g-dialog>
  </div>
</template>

<script lang="ts">
export default {
  data() {
    return {
      step: 1,
      firstInitDialog: false,
      selectedRadioItem: {},
      selectedTab: {
        text: this.$t('kyc.iranUser'),
        value: 1,
      },
      tabs: [
        {
          text: this.$t('kyc.iranUser'),
          value: 1,
        },
        {
          text: this.$t('kyc.foreignUser'),
          value: 2,
        },
        {
          text: this.$t('kyc.company'),
          value: 3,
        },
      ],
      steps: [
        {
          text: 'گام اول',
          status: 2,
        },
        {
          text: 'گام دوم',
          status: 2,
        },
        {
          text: 'گام سوم',
          status: 1,
        },
      ],
      wizardSteps: [
        {
          title: '6 دقیقه زمان',
          des: 'مدت زمان احراز هویت 6 دقیقه و تایید آنی',
          icon: 'icon-timer',
          color: '#00FF14',
          bgColor: '#E9F5E9',
        },
        {
          title: 'سیم کارت به نام',
          des: 'فعال و به نام خودتان باشد',
          icon: 'icon-simcard',
          color: '#FFC00C',
          bgColor: '#FDF6E5',
        },
        {
          title: 'مدرک هویتی',
          des: 'تصویر گذرنامه ',
          icon: 'icon-document-sketch',
          color: '#6200FF',
          bgColor: '#EDE9F5',
        },
        {
          title: 'ویدیو/عکس احراز هویت',
          des: 'عکس همراه با کارت ملی یا ویدئو سلفی با متن مشخص شده',
          icon: 'icon-profile-check',
          color: '#FF0076',
          bgColor: '#F5E9EE',
        },
      ],
    }
  },
  mounted() {
    this.firstInitDialog = true
  },
}
</script>

<style lang="scss">
.kyc-steps {
  &__header {
    margin: 0 -1rem;
    border-bottom: 1px solid $--border-color-2;
    padding: 1rem 2.5rem 1.6rem 2.5rem;
  }
  &__icon {
    font-size: 1.3rem;
    color: $--color-primary;
    margin-top: 0.4rem;
  }
  &__title {
    color: $--color-neutral-700;
    margin-right: 0.8rem;
  }
  &__body {
    max-width: 28rem;
    margin: 0 auto;
    padding-top: 1.8rem;
    padding-bottom: 1rem;
  }
  &__item {
    margin-bottom: 1.5rem;
  }
  &__item-des {
    color: $--color-neutral-300;
  }
}

.choose-group-title {
  display: flex;
  align-items: center;
  span {
    vertical-align: middle;
  }
  b {
    color: $--color-neutral-900;
    font-size: 0.9rem;
    margin: 0 0.7rem 0 1.3rem;
  }
}

.kyc-head {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1rem;
  &__phone {
    span {
      font-size: 1.1rem;
    }
    b {
      color: $--color-primary;
      margin-right: 0.7rem;
      font-weight: 700;
    }
  }
}

.kyc-info-card {
  padding: 1.5rem 2.5rem 1rem 2.5rem;
  border: 1px solid $--border-color-2;
  border-radius: 0.625rem;
  color: $--color-neutral-900;
  &__head {
    padding-bottom: 1.7rem;
    border-bottom: 1px solid $--border-color-2;
  }
  &__title {
    font-size: 1rem;
    font-weight: 600;
  }
  &__body {
    padding-top: 1.2rem;
  }
}

.lable-input-group {
  display: flex;
  align-items: center;
  margin-bottom: 0;
  &__label {
    font-size: 0.9rem;
    font-weight: 600;
    min-width: 80px;
    margin-left: 1.8rem;
    display: flex;
    align-items: center;
    padding-bottom: 1.45rem;
  }
  &__input {
    flex: 1;
  }
}
</style>
