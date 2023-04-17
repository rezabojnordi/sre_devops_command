<template>
  <div class="bankcard">
    <div class="bankcard__header">
      <div>
        <img :src="bankcardDetail.logo" alt="" />
      </div>
      <div class="flex-1">
        <span class="text-regular-4">{{ bankcardDetail.name }}</span>
        <span class="text-title-5" :class="getStatusClass(status)">{{
          getStatusText(status)
        }}</span>
      </div>
      <div class="trash">
        <span class="icon-trash" @click="deleteCard"></span>
      </div>
    </div>
    <div class="bankcard__body text-title-5">
      <span>{{ showNumberCardOrIban }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  BankcardDetailInterface,
  BankcardPropsInterface,
} from '~/types/account/bankcard.interface'
import { BankcardStatusEnum } from '~/constant/enum/bankcard.status.enum'

const props = withDefaults(defineProps<BankcardPropsInterface>(), {
  bankcardNumber: '',
  iban: '',
  status: BankcardStatusEnum.DEACTIVATE,
  showIban: false,
})
const emit = defineEmits<{
  (e: 'delete', cardNumber: string): void
}>()

const bankcardDetail: BankcardDetailInterface = useBankcards(
  props.bankcardNumber
)

const showNumberCardOrIban = computed(() =>
  props.showIban ? props.iban : formatBankcard(props.bankcardNumber)
)

const getStatusClass = (status: BankcardStatusEnum): string => {
  if (status === BankcardStatusEnum.ACTIVE) {
    return 'status__active'
  } else if (status === BankcardStatusEnum.DEACTIVATE) {
    return 'status__deactivate'
  } else {
    return 'status__waiting'
  }
}
const getStatusText = (status: BankcardStatusEnum): string => {
  if (status === BankcardStatusEnum.ACTIVE) {
    return 'تایید شده'
  } else if (status === BankcardStatusEnum.DEACTIVATE) {
    return 'رد شده'
  } else {
    return 'در انتظار تایید'
  }
}

const deleteCard = () => {
  emit('delete', props.bankcardNumber)
}
</script>

<style lang="scss" scoped>
.bankcard {
  border: 1px solid $--border-color-2;
  border-radius: 0.625rem;
  background-color: $--color-neutral-20;
  height: 8rem;
  display: flex;
  flex-direction: column;

  &__header {
    display: flex;
    background-color: $--color-white;
    padding: 1rem;
    margin: 0;
    border-bottom: 1px solid $--border-color-2;
    border-radius: 0.625rem 0.625rem 0 0;
    width: 100%;
    gap: 1rem;

    div {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
  }

  &__body {
    direction: ltr;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    height: 100%;
    color: $--color-text-placeholder;
    letter-spacing: 0.1em;
  }
}
.trash {
  cursor: pointer;
}
.status {
  &__active {
    color: $--color-success;
  }
  &__deactivate {
    color: $--color-danger;
  }
  &__waiting {
    color: $--color-warning;
  }
}
</style>
