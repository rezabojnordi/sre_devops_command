<template>
  <div class="otc">
    <GRow justify="center">
      <GCol :xs="24">
        <g-box
          :shadow="ShadowTypeEnum.BASE"
          :rounded="RoundedTypeEnum.BASE"
          class="otc__box"
        >
          <template v-if="step === 1">
            <app-otc-inputs></app-otc-inputs>
            <app-otc-detail></app-otc-detail>
            <g-btn @click="exchange(2)">تبدیل</g-btn>
            <span class="otc__box__alert text-sm-2"
              >با توجه به نوسانات قیمت نهایی معامله ممکن است کمی متفاوت
              باشد</span
            >
          </template>
          <template v-else-if="step === 2">
            <div class="otc__box__confirm">
              <div class="otc__box__confirm__title">
                <div class="otc__box__confirm__logo">
                  <img :src="otcStore.fromCurrency.img" />
                  <img :src="otcStore.toCurrency.img" />
                </div>
                <div>
                  <span class="text-title-5">{{ exchangeSummery() }}</span>
                </div>
              </div>
              <app-otc-detail></app-otc-detail>
            </div>
            <g-btn @click="done">تبدیل</g-btn>
            <g-btn class="cancel_btn" @click="exchange(1)">انصراف</g-btn>
            <span class="otc__box__alert text-sm-2"
              >با توجه به نوسانات قیمت نهایی معامله ممکن است کمی متفاوت
              باشد</span
            >
          </template>
        </g-box>
      </GCol>
    </GRow>
    <GRow justify="center">
      <GCol :xs="13">
        <g-box
          :shadow="ShadowTypeEnum.BASE"
          :rounded="RoundedTypeEnum.BASE"
          class="otc__history"
        >
          <g-tab v-model="selectedTab" :tabs="tabs">
            <app-history></app-history>
          </g-tab>
        </g-box>
      </GCol>
    </GRow>
  </div>
</template>

<script setup lang="ts">
import {
  RoundedTypeEnum,
  ShadowTypeEnum,
} from '~/constant/enum/component/global/box.enum'
import { useOtcStore } from '~/stores/otc'

const otcStore = useOtcStore()
const { $toast } = useNuxtApp()

// button tab
const tabs = ref([
  { title: 'تاریخچه سفارشات' },
  // { text: 'تاریخچه معاملات', value: 1 },
])
const selectedTab = ref<number>(0)

const step = ref<number>(1)

const exchange = (val: number) => {
  step.value = val
  console.log('exchange')
}
const done = () => {
  $toast.success('تبدیل با موفقیت انجام شد')
  step.value = 1
}
const exchangeSummery = (): string => {
  return `تبدیل ${otcStore.pay.fromAmount} ${otcStore.fromCurrency.name_fa} به ${otcStore.pay.toAmount} ${otcStore.toCurrency.name_fa}`
}
</script>

<style lang="scss" scoped>
.otc {
  background-color: $--color-neutral-20;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  min-height: 100vh;
  gap: 1rem;
  &__box {
    max-width: 510px;
    height: 590px;
    padding: 2rem;
    margin: 1rem auto;
    //width: calc(100% * 5 / 18);
    gap: 1.5rem;
    &__alert {
      text-align: center;
      color: $--color-warning-300;
    }
    &__confirm {
      border-radius: $--border-radius-base;
      padding: 2rem 1rem;
      background-color: $--color-neutral-20;
      &__logo {
        display: flex;
        height: 2rem;
        width: 2rem;
        position: relative;
        align-items: center;
        justify-content: center;
        img {
          position: absolute;
          width: 1.5rem;
          height: 1.5rem;
          &:first-child {
            transform: translate(-5px, -5px);
          }
          &:last-child {
            transform: translate(5px, 5px);
          }
        }
      }
      &__title {
        display: flex;
        align-items: center;
        gap: 1rem;
        justify-content: center;
        padding: 0 0 2rem;
      }
      &__detail {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        &__item {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
      }
    }
  }
  //&__history {
  //  width: calc(100% * 10 / 18);
  //}
}
.cancel_btn {
  background-color: $--color-neutral-30;
  color: $--color-neutral-500;
  border: none;
}
</style>
