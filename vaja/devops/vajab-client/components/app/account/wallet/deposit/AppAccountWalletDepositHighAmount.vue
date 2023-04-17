<template>
  <div class="h-100">
    <transition name="fade" mode="out-in">
      <GBox v-if="hasDepositID" class="deposit-high-amount">
        <div class="deposit-high-amount__header text-sm-1">
          <span class="icon-user-square"></span>
          <span class="mx-1">اطلاعات حساب</span>
        </div>
        <div class="deposit-high-amount__inputs">
          <span>حساب :</span>
          <GInput
            :model-value="accountNumber"
            class="flex-grow-1"
            no-error
            filled
            readonly
            @click="copy(accountNumber)"
          >
            <template #appended>
              <span class="icon-copy"></span>
            </template>
          </GInput>
        </div>
        <div class="deposit-high-amount__inputs">
          <span>شناسه واریز :</span>
          <GInput
            :model-value="depositID"
            class="flex-grow-1"
            no-error
            filled
            readonly
            @click="copy(depositID)"
          >
            <template #appended>
              <span class="icon-copy"></span>
            </template>
          </GInput>
        </div>
        <div class="deposit-high-amount__inputs">
          <span>به نام :</span>
          <GInput
            :model-value="inTheName"
            class="flex-grow-1"
            no-error
            filled
            readonly
          ></GInput>
        </div>
      </GBox>
      <div v-else class="deposit-high-amount__outer h-100">
        <GBox :loading="loadingGetDepositID" class="deposit-high-amount">
          <div class="deposit-high-amount__empty">
            <span class="icon-close-circle"></span>
            <span>درحال حاضر شما شناسه واریز ندارید</span>
          </div>
        </GBox>
        <g-btn class="w-100" @click="reqToGetDepositId"
          >ساختن شناسه واریز</g-btn
        >
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
// Load every thing you want from Nuxt🤢
const { $toast } = useNuxtApp()

// Stage 1 -> user do not create deposit ID yet
const hasDepositID = ref<boolean>(false)
const loadingGetDepositID = ref<boolean>(false)
const reqToGetDepositId = async () => {
  loadingGetDepositID.value = true
  setTimeout(() => {
    loadingGetDepositID.value = false
    hasDepositID.value = true
  }, 2000)
}

// Stage 2 -> user create and get the detail of deposit ID
const accountNumber = ref<string>('IR1233456789124657812349')
const depositID = ref<string>('140010089826')
const inTheName = ref<string>('ارتباط گستر سپهر وجب')

const permissionRead = usePermission('clipboard-read')
const permissionWrite = usePermission('clipboard-write')

const { copy, copied } = useClipboard()

watch(copied, (val) => {
  if (val) $toast.success('کپی شد.')
})
</script>

<style lang="scss" scoped>
.deposit-high-amount {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  border: 1px solid $--border-color-base;
  border-radius: $--border-radius-base;
  padding: 0.875rem 1.2rem;
  margin-bottom: 1rem;
  flex-grow: 1;
  height: 100%;
  &__header {
    display: flex;
    align-items: center;
    width: 100%;
    padding: 1rem 0;
    border-bottom: 1px solid $--color-neutral-30;
    vertical-align: middle;
  }
  &__inputs {
    display: flex;
    align-items: center;
    width: 100%;
    margin-top: 1rem;
    .icon-copy {
      cursor: pointer;
    }
    & > span {
      width: 8rem;
      color: $--color-text-placeholder;
      font-weight: 400;
      font-size: 14px;
    }
  }
  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    flex-grow: 1;
    color: $--color-text-placeholder;
    & > .icon-close-circle {
      font-size: 2rem;
      margin: 0.5rem;
    }
  }
  &__outer {
    display: flex;
    flex-direction: column;
  }
}
</style>
