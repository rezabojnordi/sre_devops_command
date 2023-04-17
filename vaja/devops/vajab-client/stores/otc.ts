import { defineStore } from 'pinia'
import { CoinInterface } from '~/types/otc/select.coin.interface'
import { OtcInputTypeEnum } from '~/constant/enum/otc.input.type.enum'
import { safeDiv, toFixedNumber } from '~/composables/useMath'
import { easyReadNumber } from '~/composables/useString'

interface State {
  pay: Pay
  feePercentage: number
  fromCurrency: CoinInterface
  toCurrency: CoinInterface
}
interface Pay {
  from: string
  to: string
  symbol: string
  fromAmount: number
  toAmount: number
}
export const useOtcStore = defineStore('otc', {
  state: (): State => {
    return {
      pay: {
        from: '',
        to: '',
        symbol: '',
        fromAmount: 1,
        toAmount: 1,
      },
      feePercentage: 2,
      fromCurrency: {
        name: '',
        symbol: '',
        img: '',
        name_fa: '',
        up: 0,
        d: 0,
      },
      toCurrency: {
        name: '',
        symbol: '',
        img: '',
        name_fa: '',
        up: 0,
        d: 0,
      },
    }
  },
  getters: {
    exchangeRate(): number {
      const { up: toUsdtPrice } = this.toCurrency
      const { up: fromUsdtPrice } = this.fromCurrency

      return toFixedNumber(safeDiv(toUsdtPrice, fromUsdtPrice), 6)
    },
    feeAmount(): number {
      const total = this.pay.toAmount * this.exchangeRate
      return toFixedNumber(safeDiv(total * this.feePercentage, 100), 6)
    },
    totalPay(): number {
      const toAmount = this.pay.toAmount
      const exRate = this.exchangeRate

      if (!toAmount || !exRate || isNaN(toAmount) || isNaN(exRate)) {
        return 0
      }
      return toAmount * exRate + this.feeAmount
    },
    getOtcBalance:
      (state) =>
      (symbol: string): number => {
        return 0.001
        // return state.balances.find((item) => item.symbol === symbol)?.balance || 0
      },
  },
  actions: {
    setOtcFrom(from: string) {
      this.pay.from = from
    },
    setPayAmount(amount: number | string) {
      if (typeof amount == 'string') {
        amount = parseInt(amount)
      }
      this.pay.toAmount = amount
    },
    setPayFromSymbol(symbol: string) {
      this.pay.from = symbol
    },
    setPayToSymbol(symbol: string) {
      this.pay.to = symbol
    },
    setCurrency(currency: CoinInterface, side: OtcInputTypeEnum) {
      if (side === OtcInputTypeEnum.FROM) {
        this.fromCurrency = currency
      } else if (side === OtcInputTypeEnum.TO) {
        this.toCurrency = currency
      }
      this.setAmount(OtcInputTypeEnum.TO, 1)
    },
    toggleOtcType() {
      ;[this.fromCurrency, this.toCurrency] = [
        this.toCurrency,
        this.fromCurrency,
      ]
    },
    setAmount(otcInputType: OtcInputTypeEnum, amount: number) {
      if (otcInputType === OtcInputTypeEnum.FROM) {
        this.pay.fromAmount = amount
        this.pay.toAmount = toFixedNumber(safeDiv(amount, this.exchangeRate), 6)
      } else if (otcInputType === OtcInputTypeEnum.TO) {
        this.pay.toAmount = amount
        this.pay.fromAmount = this.exchangeRate * amount
      }
    },
  },
})
