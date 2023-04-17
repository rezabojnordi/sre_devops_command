<template>
  <div>
    <div class="gray-box">
      <div class="gray-box__inner">
        <div class="account-form-item">
          <div class="mb-3 text-sm-2">رمز ارز خود را انتخاب نمایید</div>
          <g-select
            v-model="deposit.selectedCard"
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
          <UtilitiesButtonGroup
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
          </UtilitiesButtonGroup>
        </div>
        <g-input
          v-model="qrcode"
          readonly
          label="آدرس بیت‌کوین مقصد"
          top-label
          class="mb-2"
        >
          <template #appended>
            <div class="text-light text-regular-2 g-row g-align-center">
              <UtilitiesCopyIcon icon="icon-copy-success" :text="qrcode" />
              <Tooltip class="g-row g-align-center">
                <span class="icon-scan-barcode cursor-pointer"></span>

                <template #popper>
                  <g-qrcode :value="qrcode" />
                </template>
              </Tooltip>
            </div>
          </template>
        </g-input>
        <g-row :gutter="25">
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">کارمزد انتقال شبکه</span>
              <span class="text-regular-5">250000 IRT</span>
            </div>
          </g-col>
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">حداقل واریزی</span>
              <span class="text-regular-5">250000 IRT</span>
            </div>
          </g-col>
        </g-row>
      </div>
    </div>
    <div class="attention-text text-center">
      در انتخاب آدرس دقت کنید . ارسال رمز ارز غیر بیتکوین به این آدرس ممکن است
      منجر به از دست دادن آن برای همیشه شود .
    </div>
    <div class="text-center text-regular-4 my-3">
      برای واریز بیت‌کوین به کیف پولتان در وجب، لازم است یک آدرس واریز ایجاد
      کنید.
    </div>
    <g-btn class="w-100"> ایجاد آدرس واریز </g-btn>
  </div>
</template>

<script lang="ts">
import { Tooltip } from 'floating-vue'
import 'floating-vue/dist/style.css'

export default {
  components: {
    Tooltip,
  },
  data() {
    return {
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
        {
          protocol: 'BSC (BEP20)',
          title: 'شبکه بپ ۲۰',
          id: 4,
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
      deposit: {
        selectedCard: null,
        value: '',
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
