import { BankcardDetailInterface } from '~/types/account/bankcard.interface'

interface BankcardSource {
  name: string
  format: string
  logo: string
}

const bankcardSource = ref<BankcardSource[]>([
  { name: 'بانک ملی ایران', format: '603799', logo: 'melli.png' },
  { name: 'بانک سپه', format: '589210', logo: 'melli.png' },
  { name: 'بانک توسعه صادرات', format: '627648', logo: 'melli.png' },
  { name: 'بانک صنعت و معدن', format: '627961', logo: 'melli.png' },
  { name: 'بانک کشاورزی', format: '603770', logo: 'melli.png' },
  { name: 'بانک مسکن', format: '628023', logo: 'melli.png' },
  { name: 'پست بانک ایران', format: '627760', logo: 'melli.png' },
  { name: 'بانک توسعه تعاون', format: '502908', logo: 'melli.png' },
  { name: 'بانک اقتصاد نوین', format: '627412', logo: 'melli.png' },
  { name: 'بانک پارسیان', format: '622106', logo: 'melli.png' },
  { name: 'بانک پاسارگاد', format: '502229', logo: 'melli.png' },
  { name: 'بانک کارآفرین', format: '627488', logo: 'melli.png' },
  { name: 'بانک سامان', format: '621986', logo: 'melli.png' },
  { name: 'بانک سینا', format: '639346', logo: 'melli.png' },
  { name: 'بانک سرمایه', format: '639607', logo: 'melli.png' },
  { name: 'بانک تات', format: '636214', logo: 'melli.png' },
  { name: 'بانک شهر', format: '502806', logo: 'melli.png' },
  { name: 'بانک دی', format: '502938', logo: 'melli.png' },
  { name: 'بانک صادرات', format: '603769', logo: 'melli.png' },
  { name: 'بانک ملت', format: '610433', logo: 'mellat.png' },
  { name: 'بانک تجارت', format: '627353', logo: 'melli.png' },
  { name: 'بانک رفاه', format: '589463', logo: 'melli.png' },
  { name: 'بانک انصار', format: '627381', logo: 'melli.png' },
  { name: 'بانک مهر اقتصاد', format: '639370', logo: 'melli.png' },
])

export function useBankcards(bankcardNumber: string): BankcardDetailInterface {
  // delete all spaces
  const bankcardNumberWithoutSpaces = bankcardNumber.replace(/\s/g, '')
  // get first 6 digits
  const bankcardNumberFirstSixDigits = bankcardNumberWithoutSpaces.slice(0, 6)
  // find bankcard source
  const bankcardSourceFound = bankcardSource.value.find(
    (bankcard) => bankcard.format === bankcardNumberFirstSixDigits
  )
  const name = bankcardSourceFound?.name || 'بانک نامشخص'
  const logo = useAssetMedia(
    '/assets/images/bankcard/'.concat(bankcardSourceFound?.logo || 'melli.png')
  ) // return bankcard source
  return {
    name,
    logo,
  }
}

export function formatBankcard(card: string): string {
  // Remove any existing hyphens or spaces from the input string
  return card ? card.match(/.{1,4}/g).join('-') : ''
  // if (!card) return ''
  // return card.replace(/(.{4})/g, '$1-').trim()
}
