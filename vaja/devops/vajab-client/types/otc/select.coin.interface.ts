import { OtcInputTypeEnum } from '~/constant/enum/otc.input.type.enum'

export interface CoinInterface {
  img: string
  symbol: string
  name: string
  name_fa: string
  up: number // USDT price
  d: number // decimal
}

export type SelectCoinInterface = Pick<
  CoinInterface,
  'img' | 'symbol' | 'name' | 'name_fa'
>

export type OtcInputCurrencyInterface = Pick<
  CoinInterface,
  'img' | 'symbol' | 'name'
>

export interface OtcInputPropsInterface {
  currency: OtcInputCurrencyInterface
  otcType: OtcInputTypeEnum
  amount: number
}
