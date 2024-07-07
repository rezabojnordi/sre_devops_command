<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :tabs="tabs"
      class="wallet-assets"
      custome-middle-section
      :has-help="false"
    >
      <template #middleSection>
        <div class="wallet-assets__middle-header p-2">
          <GBtn outlined>موجودی</GBtn>
          <div>
            <g-btn text-button @click="helpPopup = true">
              <span class="mx-2 icon-info-circle"></span>
              <span>راهنما</span>
            </g-btn>
            <NuxtLink to="/account/pay/deposit">
              <g-btn>
                <span class="mx-2 icon-wallet"></span>
                <span>شناسه دریافت انی</span>
              </g-btn>
            </NuxtLink>
          </div>
        </div>
      </template>
      <GRow class="wallet-assets__header" :gutter="10">
        <GCol :xs="8">
          <div class="wallet-assets__cards wallet-assets__cards__irt">
            <img src="~/assets/images/account/wallet/irt.svg" alt="" />
            <div>
              <span class="text-regular-2"
                >معادل مجموع دارایی ها به تومان
              </span>
              <span class="text-regular-4"
                >( IRT ) <b class="text-title-3">۲۰٫۰۰۰٫۰۰۰</b></span
              >
            </div>
          </div>
        </GCol>
        <GCol :xs="8">
          <div class="wallet-assets__cards wallet-assets__cards__usdt">
            <img src="~/assets/images/account/wallet/usdt.svg" alt="" />
            <div>
              <span class="text-regular-2">معادل مجموع دارایی ها به تتر</span>
              <span class="text-regular-4"
                >( USDT ) <b class="text-title-3">۲۰٫۰۰۰٫۰۰۰</b></span
              >
            </div>
          </div>
        </GCol>
        <GCol :xs="8">
          <div class="wallet-assets__cards wallet-assets__cards__profit">
            <img src="~/assets/images/account/wallet/profit.svg" alt="" />
            <div>
              <span class="text-regular-2">سود و زیان روز گذشته</span>
              <span class="text-regular-4">
                <b class="text-title-3">۸٪</b>
                <span class="icon-finance-up mx-2"></span
              ></span>
            </div>
          </div>
        </GCol>
      </GRow>
      <GRow class="mt-4">
        <AppAccountWalletAssetsTable></AppAccountWalletAssetsTable>
      </GRow>
    </AppAccountCard>
    <utilities-side-popup v-model="helpPopup">
      <span> ببعی میگه به به </span>
    </utilities-side-popup>
  </div>
</template>

<script setup lang="ts">
import AppAccountWalletAssetsTable from '~/components/app/account/wallet/assets/AppAccountWalletAssetsTable.vue'

const selectedTab = ref({
  text: 'موجودی',
  value: 1,
})
const path = ref({
  parent: 'کیف پول',
  child: 'دارایی ها',
})
const tabs = ref([
  {
    text: 'موجودی',
    value: 1,
  },
])

// help user logic
const helpPopup = ref<boolean>(false)
</script>

<style lang="scss" scoped>
.wallet-assets {
  &__middle-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    & > div {
      display: flex;
      gap: 1rem;
      align-items: center;
      & > span {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }
    }
  }
  &__header {
    display: flex;
    flex-wrap: nowrap;
    overflow-x: scroll;
    padding-bottom: 1rem;
    & > div {
      min-width: 320px;
    }
  }
  &__cards {
    width: 100%;
    height: 7.5rem;
    border-radius: $--border-radius-base;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 3rem;
    & > div {
      display: flex;
      flex-direction: column;
      text-align: end;
    }
    &__irt {
      background: linear-gradient(93.16deg, #fcffe9 1.48%, #ffe8ba 97.99%);
    }
    &__usdt {
      background: linear-gradient(93.16deg, #e9ffee 1.48%, #c8ffba 97.99%);
    }
    &__profit {
      background: linear-gradient(93.32deg, #f2fcff -2.53%, #edfbff 98.72%);
    }
  }
}
</style>
