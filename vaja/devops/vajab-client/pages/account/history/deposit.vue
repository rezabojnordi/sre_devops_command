<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="true"
      :tabs="tabs"
      class="profile-account-card mb-3"
    >
      <AppAccountHistoryFilters :coins="coins" class="mb-3" />
      <AppAccountHistoryDeposit :items="items" />
    </AppAccountCard>
  </div>
</template>
<script lang="ts">
export default {
  data() {
    return {
      path: {
        parent: 'تاریخچه',
        child: 'واریز',
      },
      selectedTab: {
        text: 'تاریخچه واریز',
        type: 'واریز',
        value: 1,
        path: '/account/history/deposit',
      },
      tabs: [
        {
          text: 'تاریخچه واریز',
          type: 'واریز',
          value: 1,
          path: '/account/history/deposit',
        },
        {
          text: 'تاریخچه برداشت',
          type: 'برداشت',
          value: 2,
          path: '/account/history/withdraw',
        },
      ],
      searchTerm: '',
      coins: [
        {
          currency: 'BTC',
          title: 'بیت کوین',
        },
        {
          currency: 'ETH',
          title: 'اتریوم',
        },
        {
          currency: 'BNB',
          title: 'بایننس کوین',
        },
        {
          currency: 'USDT',
          title: 'تتر',
        },
        {
          currency: '',
          title: 'بیت کوین',
        },
      ],
      items: [
        {
          title: 'تتر',
          currency: 'USDT',
          amount: '29.3',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 2,
          txId: 'TR13fv1fd3g1235f4g1d41',
        },
        {
          title: 'بیت کون',
          currency: 'BTC',
          amount: '0.0025',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 1,
          txId: 'TR13fv1fd3g1235f4g1d41',
        },
        {
          title: 'تومان',
          currency: 'IRT',
          amount: '500000',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 1,
          txId: '21365215',
        },
        {
          title: 'تتر',
          currency: 'USDT',
          amount: '29.3',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 2,
          txId: 'TR13fv1fd3g1235f4g1d41',
        },
        {
          title: 'تتر',
          currency: 'USDT',
          amount: '29.3',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 2,
          txId: 'TR13fv1fd3g1235f4g1d41',
        },
        {
          title: 'تتر',
          currency: 'USDT',
          amount: '29.3',
          createdAt: '2023-02-27T07:28:49.563Z',
          status: 2,
          txId: 'TR13fv1fd3g1235f4g1d41',
        },
      ],
    }
  },
  watch: {
    selectedTab() {
      this.$router.push({
        path: this.selectedTab.path,
      })
    },
  },
}
</script>

<style lang="scss">
.key-val-filter {
  display: flex;
  align-items: center;
  flex-wrap: nowrap;
  &__text {
    margin-left: 20px;
  }
}
.filter-btn {
  min-width: 228px;
  display: flex;
  align-items: center;
  &__icon {
    vertical-align: middle;
    margin-left: 0.8rem;
  }
}
.select-input {
  .global-input__icon {
    color: $--color-neutral-500;
    font-size: 1rem;
  }
}

.divider {
  border-bottom: 1px solid $--border-color-2;
  margin: 1rem 0;
}
</style>
