<template>
  <div>
    <div class="gray-box">
      <div class="gray-box__inner">
        <div class="account-form-item">
          <div class="mb-3 text-sm-2">رمز ارز خود را انتخاب نمایید</div>
          <g-select
            v-model="withdraw.selectedCoin"
            title="رمز ارز خود را انتخاب نمایید"
            placeholder="ارز مورد نظر خود برای واریز را انتخاب کنید"
            key-name="currency"
            no-border
            has-search
            :items="coins"
          >
            <template #title="item">
              <div class="coin-select-item">
                <div class="coin-select-item__inner">
                  <img
                    src="~/assets/images/account/BTC.svg"
                    :alt="item.currency"
                  />
                  <span class="coin-select-item__title text-title-5">{{
                    item.title
                  }}</span>
                  <span class="text-light">{{ item.currency }}</span>
                </div>
                <div class="text-regular-4 text-light">
                  {{ item.selectIndex }}
                </div>
              </div>
            </template>
            <template #item="item">
              <div class="coin-select-item">
                <div class="coin-select-item__inner">
                  <img
                    src="~/assets/images/account/BTC.svg"
                    :alt="item.currency"
                  />
                  <span class="coin-select-item__title text-title-5">{{
                    item.title
                  }}</span>
                  <span class="text-light">{{ item.currency }}</span>
                </div>
                <div class="text-regular-4 text-light">
                  {{
                    ('0' + item.selectIndex).slice(
                      -(item.selectIndex.length > 1
                        ? item.selectIndex.length
                        : 2)
                    )
                  }}
                </div>
              </div>
            </template>
          </g-select>
        </div>

        <div class="account-form-item">
          <div class="mb-3 text-regular-5">نوع شبکه واریز را مشخص نمایید</div>
          <UtilitiesRadioButtonGroup
            v-model="selectedProtocol"
            key-name="id"
            :items="protocols"
          >
            <template #item="item">
              <div class="text-center p-2">
                <div class="text-title-5">
                  {{ item.protocol }}
                </div>
                <div class="text-regular-4">
                  {{ item.title }}
                </div>
              </div>
            </template>
          </UtilitiesRadioButtonGroup>
        </div>

        <div class="g-justify-space-between g-row mb-3">
          <span class="text-sm-2">آدرس مقصد</span>
          <span class="text-regular-5 g-row g-align-center">
            <span class="icon-info-circle mx-2 text-regular-3"></span>
            وارد کردن آدرس نادرست ممکن است منجر به از دست رفتن منابع مالی شما
            شود.
          </span>
        </div>

        <g-input v-model="withdraw.amount" class="mb-2" />

        <div class="g-justify-space-between g-row mb-3">
          <span class="text-sm-2">
            مقدار برداشتی
            <span class="text-regular-5 mx-1"
              >حداقل برداشت شبکه بیت کوین:
              <span class="mx-1">0.5 BTC</span></span
            >
          </span>
          <span class="text-regular-5"> قابل برداشت: 0.003 BTC </span>
        </div>
        <g-row :gutter="15">
          <g-col flex-1>
            <g-input v-model="withdraw.value" top-label class="mb-2">
              <template #appended> BTC </template>
            </g-input>
          </g-col>

          <g-col>
            <g-btn class="all-amount-btn"> کل موجودی </g-btn>
          </g-col>
        </g-row>

        <g-row :gutter="25">
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">کارمزد شبکه</span>
              <span class="text-regular-5">0.0003 BTC</span>
            </div>
          </g-col>

          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">مبلغ برداشت از کیف پول</span>
              <span class="text-regular-5">0.02126399 BTC</span>
            </div>
          </g-col>
        </g-row>
      </div>
      <div class="attention-text-warning-darker text-center mt-3">
        کارمزد انتقال(1000USDT) مربوط به ثبت تراکنس در BSC(BEP20) بوده و وجب در
        آن ذینفع نیست.
      </div>
    </div>
    <g-btn class="w-100" @click="$emit('submit')"> درخواست برداشت </g-btn>
  </div>
</template>

<script lang="ts">
export default {
  data() {
    return {
      submitDialog: false,
      qrcode: '1234567891234567891234567891234567891',
      selectedProtocol: {
        protocol: 'SegWit',
        title: 'شبکه سگویت',
        id: 1,
      },
      protocols: [
        {
          protocol: 'SegWit',
          title: 'شبکه سگویت',
          id: 1,
        },
        {
          protocol: 'Legacy',
          title: 'شبکه لگاسی',
          id: 2,
        },
        {
          protocol: 'Lightning',
          title: 'شبکه لایتینینگ',
          id: 3,
        },
      ],
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
      withdraw: {
        selectedCoin: null,
        value: '',
        amount: '',
      },
      bankCards: [
        {
          cardNumber: '5029081058996980',
        },
        {
          cardNumber: '6104338945895171',
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.coin-select-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.875rem;
  font-weight: 400;
  &__inner {
    display: flex;
    align-items: center;
  }
  img {
    height: 1.25rem;
  }
  &__title {
    margin: 0 0.625rem;
  }
}
.asset-hint {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #ededed;
  border-radius: $--border-radius-base;
  padding: 0.875rem 1.2rem;
}
.account-form-item {
  margin-bottom: 1.2rem;
}
.gray-box {
  background-color: #f6f6f6;
  border-radius: $--border-radius-base;
  padding: 1.5rem 1rem;
  margin-bottom: 1.5rem;
  &__inner {
    max-width: 41.5rem;
    margin: 0 auto;
  }
}

.card-number-item {
  display: flex;
  align-items: center;
  &__name {
    margin: 0 10px 20px 0;
  }
}
</style>
