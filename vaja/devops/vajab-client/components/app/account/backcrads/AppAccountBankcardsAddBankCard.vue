<template>
  <div class="bankcard__add p-3" :gutter="10">
    <button
      v-if="!showEnterMode"
      class="none-btn text-regular-3"
      @click="enterBankcard"
    >
      <span class="none-btn-icon icon-add-square mx-2"></span>
      <span>افزودن شماره کارت جدید</span>
    </button>
    <template v-else>
      <div class="bankcard__add__notice">
        <span class="text-sm-2">شماره کارت خود را وارد کنید</span>
        <span class="text-regular-5"
          >توجه : شماره شبا وارد شده باید به نام
          <b>محمد معین اکبری</b> باشد</span
        >
        <button class="none-btn text-regular-4" @click="exitEnterMode">
          <span class="mx-1">انصراف</span>
          <span class="none-btn-icon icon-close-square"></span>
        </button>
      </div>
      <div class="bankcard__add__input mt-3">
        <g-input
          v-model="bankcardNumber"
          no-error
          class="flex-1 ml-2"
        ></g-input>
        <g-btn outlined @click="submitCard">ثبت کارت</g-btn>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
const formatNumber = (card: string): string => {
  if (!card) return ''
  return card?.replace(/(.{4})/g, '$1 ').trim()
}

const showEnterMode = ref(false)

const enterBankcard = () => {
  showEnterMode.value = true
}
const exitEnterMode = () => {
  bankcardNumber.value = ''
  showEnterMode.value = false
}

const bankcardNumber = ref<string>('')
const submitCard = () => {
  alert(`card has submit ${bankcardNumber.value}`)
}
</script>

<style lang="scss" scoped>
.bankcard__add {
  width: 100%;
  border: 1px solid $--border-color-2;
  border-radius: 0.625rem;
  background-color: $--color-neutral-20;
  text-align: center;
  display: flex;
  justify-content: center;
  flex-direction: column;

  &__notice {
    display: flex;
    gap: 0.5rem;
    & > span {
      &:nth-child(2) {
        flex-grow: 1;
        text-align: right;
        color: $--color-danger-300;
        align-self: center;
      }
    }
  }
  &__input {
    display: flex;
  }
  .none-btn {
    border: none;
    outline: none;
    padding: 0;
    background-color: transparent;
    cursor: pointer;
    color: $--color-text-placeholder;
    &-icon {
      vertical-align: middle;
    }
  }
}
</style>
