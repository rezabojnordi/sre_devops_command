<template>
  <div class="otc-inputs">
    <div>
      <div class="otc-inputs__pay mb-2">
        <span class="text-sm-2">پرداخت میکنم :</span>
        <div>
          <span class="text-regular-4">موجودی :</span>
          <span class="text-title-5">
            <span>{{ otcStore.fromCurrency.symbol }}</span>
            <span class="mx-1"></span>
            <span>{{
              otcStore.getOtcBalance(otcStore.fromCurrency.symbol)
            }}</span>
          </span>
          <nuxt-link
            to="/account/assets/deposit"
            class="icon-wallet-add color-primary"
          ></nuxt-link>
        </div>
      </div>
      <app-otc-input
        :currency="reactivePick(otcStore.fromCurrency, 'img', 'symbol', 'name')"
        :otc-type="OtcInputTypeEnum.FROM"
        :amount="otcStore.pay.fromAmount"
        @openSelectCoin="openSelectCoin($event)"
      ></app-otc-input>
    </div>
    <div class="otc-inputs__converter">
      <span class="icon-sort" @click="toggleOtc"></span>
    </div>
    <div class="otc-inputs__receive">
      <div class="text-sm-2 mb-2">دریافت میکنم :</div>
      <app-otc-input
        :currency="reactivePick(otcStore.toCurrency, 'img', 'symbol', 'name')"
        :otc-type="OtcInputTypeEnum.TO"
        :amount="otcStore.pay.toAmount"
        @openSelectCoin="openSelectCoin($event)"
      ></app-otc-input>
    </div>
    <common-select-coin
      v-model="isOpenSelectCoin"
      :coins="selectCoinSource"
      :header="selectTabHeader"
      @select="selectSymbolEvent"
    ></common-select-coin>
  </div>
</template>

<script setup lang="ts">
import {
  CoinInterface,
  SelectCoinInterface,
} from '~/types/otc/select.coin.interface'
import { OtcInputTypeEnum } from '~/constant/enum/otc.input.type.enum'
import { useOtcStore } from '~/stores/otc'

/**
 * get list of coin
 * can pay list -> fromCurrencyList
 * can get list -> toCurrencyList
 * **/
let fromCurrencyList = ref<Array<CoinInterface>>([
  {
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/825.png',
    symbol: 'USDT',
    name: 'Tether',
    name_fa: 'تتر',
    up: 1,
    d: 6,
  },
  {
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png',
    symbol: 'USDC',
    name: 'USD Coin',
    name_fa: 'یو اس دی سی',
    up: 1.1,
    d: 2,
  },
  {
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/4687.png',
    symbol: 'BUSD',
    name: 'Binance USD',
    name_fa: 'بایننس یو اس دی',
    up: 0.9,
    d: 0,
  },
])
let toCurrencyList = ref<Array<CoinInterface>>([
  {
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    symbol: 'BTC',
    name: 'Bitcoin',
    name_fa: 'بیت‌کوین ',
    up: 23000,
    d: 8,
  },
  {
    img: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
    symbol: 'ETH',
    name: 'Ethereum',
    name_fa: 'اتریوم',
    up: 1600,
    d: 6,
  },
])

/**
 * selected coin for pay and get
 * **/
const otcStore = useOtcStore()

const setCurrencies = (fromIndex = 0, toIndex = 0) => {
  otcStore.setCurrency(fromCurrencyList.value[0], OtcInputTypeEnum.FROM)
  otcStore.setCurrency(toCurrencyList.value[0], OtcInputTypeEnum.TO)
}

setCurrencies()

otcStore.setAmount(OtcInputTypeEnum.TO, 1)

/**
 * coin can select that fill with fromCurrencyList, toCurrencyList
 * **/
let selectCoinSource = ref<Array<SelectCoinInterface>>()
let isOpenSelectCoin = ref<boolean>(false) // show dialog for select coin
let otcInputType = ref<OtcInputTypeEnum>(OtcInputTypeEnum.FROM) // define what otc input has selected
const openSelectCoin = (otcInput: OtcInputTypeEnum) => {
  otcInputType.value = otcInput
  selectCoinSource =
    otcInputType.value === OtcInputTypeEnum.FROM
      ? fromCurrencyList
      : toCurrencyList
  isOpenSelectCoin.value = true
}
const selectTabHeader = ref<string>('')

const selectSymbolEvent = (symbol: SelectCoinInterface) => {
  const src =
    otcInputType.value === OtcInputTypeEnum.FROM
      ? fromCurrencyList.value
      : toCurrencyList.value
  const coin = src.find((el) => el.symbol === symbol.symbol)
  if (!coin) {
    return
  }
  otcStore.setCurrency(coin, otcInputType.value)
  isOpenSelectCoin.value = false
}

const toggleOtc = () => {
  otcStore.toggleOtcType()
  ;[fromCurrencyList, toCurrencyList] = [toCurrencyList, fromCurrencyList]
  // setCurrencies()
}
</script>

<style scoped lang="scss">
.otc-inputs {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  &__pay {
    display: flex;
    justify-content: space-between;
    div {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
  }
  &__converter {
    display: flex;
    justify-content: center;
    z-index: 1;
    margin-bottom: -2rem;
    span {
      transition: 0.4s transform;
      cursor: pointer;
      background: $--color-primary;
      padding: 0.75rem;
      border-radius: 50%;
      color: $--color-white;
      &:hover {
        transform: rotate(180deg) scale(1.1) rotate3d(0, 0, 1, 0deg);
      }
    }
  }
  &__submit {
    display: flex;
    align-items: flex-end;
    width: 100%;
    flex-grow: 1;
    &__btn {
      width: 100%;
    }
  }
}
</style>
