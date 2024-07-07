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
          <AppAccountWalletWithdrawFiat
            v-if="selectedTab.value === 1"
            @submit="submitDialog = true"
          />
          <AppAccountWalletWithdrawCrypto
            v-if="selectedTab.value === 2"
            @submit="submitDialog = true"
          />
        </g-col>
        <g-col :xs="24" :lg="12">
          <app-account-attention-notes
            :items="attentionItems"
            title="نکات قبل از برداشت"
          />
        </g-col>
      </g-row>
    </AppAccountCard>
    <div class="simple-card my-4">
      <div class="simple-card__head">تاریخچه برداشت های اخیر</div>
      <AppAccountHistoryWithdraw :items="historyItems" />
    </div>
    <UtilitiesSidePopup
      v-model="submitDialog"
      :v-show-mode="true"
      title="تاییدیه برداشت"
    >
      <Form
        v-slot="{ errors }"
        class="column-full-height"
        :validation-schema="formSchema"
        @submit="login()"
      >
        <div>
          <h1 class="text-title-4">کد شناسایی ۲ عاملی</h1>

          <div class="text-light text-regular-4 mb-2">
            کد شناسایی ۲عاملی ارسال شده از طریق نرم افزار Authenticator را در
            کادر زیر وارد کنید
          </div>
          <div class="form-item">
            <Field v-slot="{ field }" name="verificationCode">
              <g-input
                v-model="verificationCode"
                label="کد شناسایی 2عاملی"
                icon="icon-note"
                maxlength="6"
                type="tel"
                :error="errors.verificationCode"
                v-bind="field"
                autocomplete="off"
              />
            </Field>
          </div>
        </div>
        <div class="mt-auto">
          <g-btn class="w-100" :loading="loading">تایید</g-btn>
          <g-btn
            class="w-100 mt-3"
            plain
            type="info"
            @click="submitDialog = false"
            >انصراف</g-btn
          >
        </div>
      </Form>
    </UtilitiesSidePopup>
  </div>
</template>

<script setup lang="ts">
const loading = ref<boolean>(false)
const submitDialog = ref<boolean>(false)
const verificationCode = ref<string>('')
const formSchema = ref({
  verificationCode: (value: string) => {
    return value?.length === 6
      ? true
      : 'لطفا کد 2عاملی معتبر و 6 رقمی وارد کنید'
  },
})
const path = ref({
  parent: 'کیف پول',
  child: 'برداشت',
})
const selectedTab = ref({
  text: 'برداشت تومانی',
  value: 1,
})
const tabs = ref([
  {
    text: 'برداشت تومانی',
    value: 1,
  },
  {
    text: 'برداشت ارزی',
    value: 2,
  },
])
const attentionItems = ref([
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
])
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
