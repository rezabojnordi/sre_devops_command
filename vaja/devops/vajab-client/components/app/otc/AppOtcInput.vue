<template>
  <div class="otc-input">
    <g-input
      :model-value="amount.toString()"
      is-number
      text-align="left"
      filled
      no-error
      @update:model-value="setPrice($event)"
    >
      <template #prepended>
        <div class="otc-input__options" @click="openSelectCoin">
          <span class="icon-down"></span>
          <img :src="currency.img" alt="" />
          <span class="text-title-5">{{ currency.name }}</span>
          <span class="text-regular-4">{{ currency.symbol }}</span>
        </div>
      </template>
    </g-input>
  </div>
</template>

<script setup lang="ts">
import { OtcInputPropsInterface } from '~/types/otc/select.coin.interface'
import { useOtcStore } from '~/stores/otc'
import { OtcInputTypeEnum } from '~/constant/enum/otc.input.type.enum'

const props = withDefaults(defineProps<OtcInputPropsInterface>(), {
  currency: () => ({
    name: '',
    symbol: '',
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
  }),
})

const emit = defineEmits<{
  (e: 'openSelectCoin', inputType: OtcInputTypeEnum): void
}>()

const inputVal = ref<string>('')
const otcStore = useOtcStore()
// const amount = computed(() => {
//   return props.otcType === OtcInputTypeEnum.FROM
//     ? otcStore.pay.fromAmount
//     : otcStore.pay.toAmount
// })

// // otcStore.
// watch(inputVal, (val: string) => {
//   // otcStore.setPayAmount(val)
//   // otcStore.setPayFrom(props.currency.symbol)
//   otcStore.setAmount(props.otcType, parseFloat(val))
// })

const setPrice = (val: string) => {
  console.log('val', val)
  otcStore.setAmount(props.otcType, parseFloat(val))
}

const openSelectCoin = () => {
  emit('openSelectCoin', props.otcType)
}
</script>

<style scoped lang="scss">
.otc-input {
  &__options {
    cursor: pointer;

    .dir-ltr {
      direction: ltr !important;
    }
    display: flex;
    align-items: center;
    gap: 0.5rem;
    img {
      width: 1.5rem;
      height: 1.5rem;
    }
  }
}
</style>
