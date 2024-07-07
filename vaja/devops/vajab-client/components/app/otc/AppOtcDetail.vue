<template>
  <div class="otc-detail">
    <div class="otc-detail__item">
      <span class="text-regular-4">نرخ تبدیل :</span>
      <span class="text-title-5">{{ otcStore.exchangeRate }}</span>
    </div>
    <div class="otc-detail__item">
      <span class="text-regular-4">کارمزد :</span>
      <span class="text-title-5">{{ otcStore.feeAmount }}</span>
    </div>
    <div class="otc-detail__item">
      <span class="text-regular-4">مقدار نهایی دریافتی :</span>
      <span class="text-title-5">{{ otcStore.totalPay }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useOtcStore } from '~/stores/otc'

const otcStore = useOtcStore()
</script>

<style scoped lang="scss">
.otc-detail {
  &__item {
    display: flex;
    justify-content: space-between;
    margin-bottom: 1rem;
  }
}
</style>
