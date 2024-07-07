import { BankcardStatusEnum } from '~/constant/enum/bankcard.status.enum'

export interface BankcardPropsInterface {
  bankcardNumber: string
  status: BankcardStatusEnum
  showIban: boolean
  iban: string
}

export interface Bankcard {
  id: number
  number: string
  iban: string
  status: string
}

export interface BankcardDetailInterface {
  name: string
  logo: string
}

export interface ListBankcardResponseInterface {
  id: number
}
