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
          <AppAccountWalletDepositFiat
            v-if="selectedTab.value === DepositTypeEnum.FIAT"
          />
          <AppAccountWalletDepositCrypto
            v-if="selectedTab.value === DepositTypeEnum.CRYPTO"
          />
          <AppAccountWalletDepositHighAmount
            v-if="selectedTab.value === DepositTypeEnum.HIGH_AMOUNT"
          />
        </g-col>
        <g-col :xs="24" :lg="12">
          <AppAccountAttentionNotes
            :items="attention"
            title="نکات قبل از واریز"
          />
        </g-col>
      </g-row>
    </AppAccountCard>
    <div>
      <div class="simple-card my-4">
        <div class="simple-card__head">تاریخچه واریزهای اخیر</div>
        <AppAccountHistoryDeposit :items="historyItems" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
enum DepositTypeEnum {
  FIAT = 1,
  CRYPTO = 2,
  HIGH_AMOUNT = 3,
}
const path = ref({
  parent: 'کیف پول',
  child: 'واریز',
})
const selectedTab = ref<{
  text: string
  value: DepositTypeEnum
}>({
  text: 'واریز تومانی',
  value: DepositTypeEnum.FIAT,
})
const tabs = ref([
  {
    text: 'واریز تومانی',
    value: DepositTypeEnum.FIAT,
  },
  {
    text: 'واریز ارزی',
    value: DepositTypeEnum.CRYPTO,
  },
  {
    text: 'واریز مبالغ بیشتر از ۵۰ میلیون تومان',
    value: DepositTypeEnum.HIGH_AMOUNT,
  },
])

// attention note
const attentionItems = ref<{
  [key in keyof typeof DepositTypeEnum]?: Array<{
    text: string
  }>
}>({
  [DepositTypeEnum.FIAT]: [
    {
      text: 'توجه داشته باشید اطلاعات هویتی ثبت شده قابل تغییر یا ویرایش نیست.',
    },
    {
      text: 'در هنگام وارد کردن نام و نام خانوادگی به تمام موارد مانند همزه، تشدید ،آ ،ا ، فاصله بین نام و نام خانوادگی های دو قسمتی ، پسوند و پیشوند های نام و نام خانوادگی و غیره دقت نمایید همه چیز باید مطابق مدارک هویتی باشد .',
    },
    {
      text: 'کد ملی بدون خط تیره وارد شود',
    },
    {
      text: 'درصورت بروز هرگونه مشکل در انجام فرایند میتوانید از طریق پشتیبانی آنلاین وجب با کارشناسان در ارتباط باشید.',
    },
  ],
  [DepositTypeEnum.CRYPTO]: [
    {
      text: 'توجه داشته باشید اطلاعات هویتی ثبت شده قابل تغییر یا ویرایش نیست.',
    },
    {
      text: 'در هنگام وارد کردن نام و نام خانوادگی به تمام موارد مانند همزه، تشدید ،آ ،ا ، فاصله بین نام و نام خانوادگی های دو قسمتی ، پسوند و پیشوند های نام و نام خانوادگی و غیره دقت نمایید همه چیز باید مطابق مدارک هویتی باشد .',
    },
    {
      text: 'کد ملی بدون خط تیره وارد شود',
    },
    {
      text: 'درصورت بروز هرگونه مشکل در انجام فرایند میتوانید از طریق پشتیبانی آنلاین وجب با کارشناسان در ارتباط باشید.',
    },
  ],
  [DepositTypeEnum.HIGH_AMOUNT]: [
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
      text: 'سقف واریز تومانی برای سطح کاربری یک، مبلغ پانصد هزار تومان در هر ۲۴ ساعت است.',
    },
  ],
})

const attention = computed(() => attentionItems.value[selectedTab.value.value])

const historyItems = ref([
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
])
</script>

<style lang="scss" scoped>
.simple-card {
  background-color: $--color-white;
  border-radius: 0.7rem;
  padding: 2rem 2.5rem;
  &__head {
    border-bottom: 1px solid $--border-color-base;
    padding-bottom: 2rem;
    margin-bottom: 2rem;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
  }
}
</style>
