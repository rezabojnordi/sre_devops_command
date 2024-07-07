<template>
  <div class="wallet-assets-table">
    <GRow justify="space-between" alignment="center">
      <GCol :xs="6">
        <GInput
          v-model="searchTerm"
          no-error
          class="w-100"
          filled
          placeholder="جستجو در دارایی ها"
        >
          <template #prepended>
            <span class="icon-search-normal"></span>
          </template>
        </GInput>
      </GCol>
      <GCheckbox>مخفی کردن دارایی های صفر</GCheckbox>
    </GRow>
    <div class="wallet-assets-table__content">
      <g-table :items="filteredList" :headers="headers">
        <template #currency="item">
          <div class="table-currency">
            <img src="~/assets/images/account/BTC.svg" :alt="item.currency" />
            <span v-if="item.currency == 'IRT'">تومان</span>
            <span v-else>{{ item.title }} ({{ item.currency }})</span>
          </div>
        </template>

        <template #amount="item">
          <span class="mx-1 text-regular-5">{{ item.currency }}</span>
          <b>{{ easyReadNumber(item.amount).show }}</b>
        </template>

        <template #irtAmount="item">
          <b>{{ easyReadNumber(item.irtAmount).show }}</b>
          <span class="mx-1 text-regular-5">تومان</span>
        </template>

        <template #action="item">
          <div class="wallet-assets-table__content__action">
            <nuxt-link to="/account/assets/deposit"
              ><span class="icon-card-receive"></span
              ><span>واریز</span></nuxt-link
            >
            <nuxt-link to="/account/assets/withdraw"
              ><span class="icon-card-send"></span
              ><span>برداشت</span></nuxt-link
            >
            <!-- TODO: define history -->
            <!--            <nuxt-link to='/account/'-->
            <!--              ><span class="icon-directbox-notif"></span-->
            <!--              ><span>تاریخچه</span></nuxt-link-->
            <!--            >-->
            <nuxt-link
              v-if="hasBuyAndSellButton(item.currency)"
              :to="`/otc?currency=${item.currency}`"
            >
              <span class="color-primary">خرید و فروش</span>
            </nuxt-link>
          </div>
        </template>
      </g-table>
    </div>
  </div>
</template>

<script setup lang="ts">
const headers = ref([
  {
    text: 'ارز',
    value: 'currency',
    minWidth: 120,
  },
  {
    text: 'موجودی',
    value: 'amount',
    minWidth: 120,
  },
  {
    text: 'معادل تومانی',
    value: 'irtAmount',
    minWidth: 115,
  },
  {
    text: '',
    value: 'action',
    minWidth: 400,
  },
])
const items = ref([
  {
    title: 'تتر',
    currency: 'USDT',
    amount: '29.3',
    createdAt: '2023-02-27T07:28:49.563Z',
    irtAmount: '2850000',
    status: 2,
    txId: 'TR13fv1fd3g1235f4g1d41',
  },
  {
    title: 'بیت کون',
    currency: 'BTC',
    amount: '0.0025',
    irtAmount: '6002521',
    status: 1,
    txId: 'TR13fv1fd3g1235f4g1d41',
  },
  {
    title: 'تومان',
    currency: 'IRT',
    amount: '16509000',
    irtAmount: '16509000',
    status: 1,
    txId: 'TR13fv1fd3g1235f4g1d41',
  },
])
const searchTerm = ref<string>('')
const filteredList = useArrayFilter(items, (i) => {
  if (searchTerm.value === '') return true
  return JSON.stringify([i.title, i.currency.toLowerCase()]).includes(
    searchTerm.value.toLowerCase()
  )
})

const hasBuyAndSellButton = (symbol: string) => {
  return symbol.toLowerCase() !== 'irt'
}
</script>

<style lang="scss" scoped>
.wallet-assets-table {
  width: 100%;
  &__content {
    img {
      vertical-align: middle;
      margin-left: 10px;
    }
    &__action {
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
      & > * {
        background: $--color-white;
        border-radius: $--border-radius-base;
        padding: 0.5rem;
        width: 7rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.25rem;
        color: #3a3635;
      }
    }
  }
}
</style>
