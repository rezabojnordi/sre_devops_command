<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="false"
      :tabs="tabs"
      class="profile-account-card"
    >
      <g-row :gutter="30">
        <g-col :xs="24" :lg="12">
          <AppAccountPayEntry :method="payMethod"></AppAccountPayEntry>
        </g-col>
        <g-col :xs="24" :lg="12">
          <app-account-attention-notes
            :items="attentionItems"
            title="نکات مهم قبل از واریز"
          />
        </g-col>
      </g-row>
    </AppAccountCard>
  </div>
</template>

<script lang="ts">
import { PayEntryMethod } from '~/constant/enum/pay.enum'

export default {
  data() {
    return {
      path: {
        parent: 'پرداخت',
        child: 'پرداخت سریع',
      },
      selectedTab: {
        text: 'پرداخت تومانی',
        value: 1,
      },
      tabs: [
        {
          text: 'پرداخت تومانی',
          value: 1,
        },
        {
          text: 'پرداخت ارزی',
          value: 2,
        },
      ],
      attentionItems: [
        {
          text: 'حتماً به آدرس صفحه‌ی درگاه بانکی دقت نموده و تنها پس از اطمینان از حضور در سایت‌های سامانه‌ی شاپرک مشخصات کارت بانکی خود را وارد نمایید.',
        },
        {
          text: 'در صفحه درگاه دقت کنید که حتما مبلغ نمایش داده شده درست باشد.',
        },
        {
          text: 'در تعیین مبلغ واریز به این موضوع دقت نمایید که حداقل مبلغ معامله در بازار وجب 300,000 تومان است.',
        },
        {
          text: 'سقف واریز تومانی برای سطح کاربری یک، م بلغ پانصد هزار تومان در هر ۲۴ ساعت است.',
        },
      ],
      historyItems: [
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
  computed: {
    payMethod(): PayEntryMethod {
      console.log(22, this.selectedTab.value)
      return this.selectedTab.value === 1
        ? PayEntryMethod.FIAT
        : PayEntryMethod.CRYPTO
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
