<template>
  <div>
    <g-card class="pay-entry">
      <g-row :gutter="10">
        <g-col :xs="24" :lg="12">
          <g-input
            v-model="amount"
            usage-type="number"
            top-label
            label="مبلغ انتقال به تومان"
            :error="meta.dirty && errors.amount"
          >
            <template #appended>
              <span class="text-regular-4">{{ symbol }}</span>
            </template>
          </g-input>
        </g-col>
        <g-col :xs="24" :lg="12">
          <g-input
            v-model="destAddr"
            usage-type="bankcard"
            top-label
            label="شناسه مقصد را وارد کنید"
            :error="meta.dirty && errors.destAddr"
          ></g-input>
        </g-col>
      </g-row>
      <g-textarea
        v-model="test"
        class="pay-entry__inputs__summery"
        label="شرح انتقال"
      ></g-textarea>
      <div v-if="showSelectCard" class="pay-entry__card">
        <div class="pay-entry__card__select my-3">
          <span class="flex-grow-1 text-sm-2">انتخاب کارت بانکی</span>
          <span class="icon-add-square mx-1"></span>
          <span class="text-regular-5">افزودن کارت بانکی</span>
        </div>
        <g-select
          v-model="selectedCard"
          title="کارت بانکی"
          placeholder="کارت بانکی مورد نظر را انتخاب کنید"
          key-name="cardNumber"
          :items="bankCards"
        >
          <template #title="item">
            <div class="text-regular-5 card-number-item">
              <img
                :src="useBankcards(item.cardNumber).logo"
                :alt="useBankcards(item.cardNumber).name"
              />
              <span class="card-number-item__name">
                {{ useBankcards(item.cardNumber).name }}
              </span>
              <b class="rtl-nums">
                {{ formatBankcard($filters.cardNumberMask(item.cardNumber)) }}
              </b>
            </div>
          </template>
          <template #item="item">
            <div class="text-regular-5 card-number-item">
              <img
                :src="useBankcards(item.cardNumber).logo"
                :alt="useBankcards(item.cardNumber).name"
              />
              <span class="card-number-item__name">
                {{ useBankcards(item.cardNumber).name }}
              </span>
              <b class="rtl-nums">
                {{ formatBankcard($filters.cardNumberMask(item.cardNumber)) }}
              </b>
            </div>
          </template>
        </g-select>
        <AppAccountPayCheckbox
          class="my-3"
          pre-icon="icon-wallet"
          title="استفاده از موجودی کیف پول تومانی"
          :sub-title="`${easyReadNumber(userBalance, 1).show}  تومان`"
        ></AppAccountPayCheckbox>
      </div>
      <hr class="dashed my-5" />
      <div
        v-show="userRemindAmount > 0"
        class="pay-entry__confirm text-title-4"
      >
        <span>مبلغ نهایی قابل پرداخت</span>
        <span class="pay-entry__confirm__quantity text-title-3">{{
          easyReadNumber(userRemindAmount, 1).show
        }}</span>
        <span class="pay-entry__confirm__quantity">{{ symbol }}</span>
        <span>می باشد</span>
      </div>
    </g-card>
    <g-btn class="w-100 mt-3" @click="pay">انتقال</g-btn>
    <g-dialog v-model="cannotDirectBankPay">
      <div class="pay-entry__not-enough-balance p-4">
        <img src="~/assets/images/failed-dialog.svg" alt="" />
        <span class="text-title-4 my-4">موجودی شما کافی نمی باشد.</span>
        <g-btn outlined>افزایش موجودی</g-btn>
        <g-btn
          class="text-regular-5 mt-3"
          text-button
          @click="cannotDirectBankPay = false"
          >انصراف</g-btn
        >
      </div>
    </g-dialog>
  </div>
</template>

<script setup lang="ts">
import { PayEntryMethod } from '~/constant/enum/pay.enum'
import { useForm } from 'vee-validate'
import { number, object, string } from 'yup'
import { RULES } from '~/constant/form/error'

const VAJAB_NUMBER_CARD_LENGTH = 16
const PAY_MAX_AMOUNT_DIRECT_BANK = 50000000
interface PayEntryPropsInterface {
  method: PayEntryMethod
}

const test = ref<string>('')

const props = defineProps<PayEntryPropsInterface>()

// const { value, errorMessage } = useField()

const schema = object({
  amount: number().required().positive().default(0),
  destAddr: string()
    .required()
    .length(VAJAB_NUMBER_CARD_LENGTH)
    .matches(RULES.isDigitString.regex, {
      message: RULES.isDigitString.msg,
    }),
})

const { useFieldModel, errors, setFieldError, meta } = useForm({
  validationSchema: schema,
})

const [amount, destAddr] = useFieldModel(['amount', 'destAddr'])

const symbol = computed(() =>
  props.method === PayEntryMethod.FIAT ? 'تومان' : 'USDT'
)
const showSelectCard = computed(() => props.method === PayEntryMethod.FIAT)

const bankCards = ref([
  {
    cardNumber: '5029081058996980',
  },
  {
    cardNumber: '6104338945895171',
  },
])
const selectedCard = ref()

const userBalance = ref<number>(100000)

const destinationAddress = ref<string>('')
const userRemindAmount = computed(() => {
  return amount.value - userBalance.value
})

const cannotDirectBankPay = ref<boolean>(false)

const pay = () => {
  if (userRemindAmount.value <= 0) {
    alert('پرداخت با کسر از حساب')
  } else if (userRemindAmount.value < PAY_MAX_AMOUNT_DIRECT_BANK) {
    alert('میتونید برید درگاه')
  } else {
    cannotDirectBankPay.value = true
  }
  // cannotDirectBankPay.value = true
}

/**
 * set dest address from url
 * for example when share link
 */
const { query } = useRoute()
console.log('query', query)
if (query && query.destAddr) {
  const { destAddr: destAddrInQuery } = query
  destAddr.value = destAddrInQuery
}
</script>

<style lang="scss" scoped>
.pay-entry {
  &__card {
    &__select {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    &__dropdown {
      &__title {
        background-color: $--color-white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.5rem;
        border-radius: $--border-radius-base;
      }
    }
  }
  &__confirm {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.25rem;
    &__quantity {
      color: $--color-success-300;
    }
  }
  &__not-enough-balance {
    display: flex;
    flex-direction: column;
    text-align: center;
    span {
      color: $--color-danger-300;
    }
  }
}
</style>
