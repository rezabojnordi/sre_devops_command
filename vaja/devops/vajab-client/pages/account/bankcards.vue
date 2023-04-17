<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="true"
      :tabs="tabs"
      class="profile-account-card"
      @openHelp="helpPopup = true"
    >
      <div class="bankcards">
        <AppAccountBankcardsBankCard
          v-for="bankcard in bankcards"
          :key="bankcard.number"
          class="bankcards__item"
          :show-iban="selectedTab.value == 2"
          :bankcard-number="bankcard.number"
          :status="bankcard.status"
          :iban="bankcard.iban"
          @delete="deleteCard"
        ></AppAccountBankcardsBankCard>
        <AppAccountBankcardsAddBankCard
          class="bankcards__item"
        ></AppAccountBankcardsAddBankCard>
      </div>
    </AppAccountCard>
    {{ isDeleteBankcard }}
    <g-dialog v-model="isDeleteBankcard">
      <div class="card__delete__box text-title-5">
        <span>آیا شماره کارت</span>
        <span class="card__delete__box__number text-regular-2">
          {{ formatBankcard(deletedCard) }}
        </span>
        <span>حذف شود ؟</span>
        <div class="card__delete__box__button">
          <g-btn class="mx-1" outlined>حذف</g-btn>
          <g-btn class="mx-1" @click="cancelDeleteCard">انصراف</g-btn>
        </div>
      </div>
    </g-dialog>
  </div>
</template>

<script setup lang="ts">
import { Bankcard } from '~/types/account/bankcard.interface'
import { BankcardStatusEnum } from '~/constant/enum/bankcard.status.enum'

const path = ref({
  parent: 'حساب کاربری',
  child: 'حساب های بانکی',
})
const selectedTab = ref({
  text: 'شماره کارت',
  value: 1,
})

const tabs = ref([
  {
    text: 'شماره کارت',
    value: 1,
  },
  {
    text: 'شماره شبا',
    value: 2,
  },
])
const helpPopup = ref(false)

const bankcards = ref<Array<Bankcard>>([
  {
    id: 0,
    number: '6104337300957733',
    iban: 'IR12345678',
    status: BankcardStatusEnum.ACTIVE,
  },
])

// dialogs
const isDeleteBankcard = ref<boolean>(false)
const deletedCard = ref<string>('')
const deleteCard = (cardNumber: string) => {
  deletedCard.value = cardNumber
  isDeleteBankcard.value = true
}
const cancelDeleteCard = () => {
  deletedCard.value = ''
  isDeleteBankcard.value = false
}
</script>

<style lang="scss">
.bankcards {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.5rem;
}
.input-edit-icon {
  color: #c8c7c6;
  margin-right: 0.2rem;
  cursor: pointer;
}

.input-success-icon {
  color: $--color-success-300;
  margin-right: 0.2rem;
}

.profile-account-card {
  .account-card {
    min-height: calc(100vh - 110px);
  }
}

.card__delete__box {
  display: flex;
  flex-direction: column;
  align-items: center;
  &__number {
    direction: ltr;
    border-radius: $--border-radius-base;
    border: 1px solid $--border-color-2;
    padding: 1rem 2.25rem;
    margin: 1rem 0;
  }
  &__button {
    margin-top: 2rem;
  }
}
</style>
