<template>
  <section class="coin-top-sec">
    <div class="main-container">
      <div class="coin-top-sec__head">
        <div class="coin-top-sec__currency-info">
          <img src="@/assets/images/BTC.svg" alt="BTC" />
          <div class="coin-top-sec__currency-info-detail">
            <div class="text-title-2">بیت کوین</div>
            <div class="text-regular-4">
              با صرافی ارز دیجیتال وجب می‌توانید به آسانی و در کمترین زمان به
              خرید و فروش بیت کوین و مشاهده قیمت روز بیت کوین بپردازید.
            </div>
          </div>
        </div>
        <div class="text-reverse">
          <div class="text-regular-5 mb-2">قیمت بیت‌کوین</div>
          <div class="text-title-3">
            ۹۹,۰۹۵,۷۴۱,۶۴۲ <span class="text-regualr-5">تومان</span>
          </div>
        </div>
      </div>
      <g-row :gutter="30">
        <g-col :xs="16">
          <div class="coin-top-sec__box">
            <div class="coin-top-sec__chart-head">
              <div class="text-title-4">BTC</div>
              <div>
                <span class="text-title-5 mx-3">16,543,35 $</span>
                <span class="text-title-4 coin-top-sec__change">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="10"
                    height="10"
                    viewBox="0 0 10 10"
                    fill="none"
                  >
                    <path
                      d="M4.99998 8.50344H3.44248C1.51164 8.50344 0.718309 7.1326 1.68664 5.45844L2.46831 4.11094L3.24998 2.76344C4.21831 1.08927 5.79914 1.08927 6.76748 2.76344L7.54914 4.11094L8.33081 5.45844C9.29914 7.1326 8.50581 8.50344 6.57498 8.50344H4.99998Z"
                      stroke-width="1.5"
                      stroke-miterlimit="10"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  +۸.۷۵٪
                </span>
              </div>
            </div>
            <div class="coin-top-sec__chart">
              <app-coins-tradingview-chart
                class="coin-top-sec__chart-inner"
                :options="tradingviewTechnicalOptions"
              />
            </div>
            <div class="coin-top-sec__detail">
              <g-row :y-gutter="20" :gutter="20">
                <g-col :xs="8">
                  <div class="text-regular-6">حجم معاملات (۲۴h)</div>
                  <div class="text-title-4">
                    ۹۳۳,۴۲۵,۶۵۵,۴۷۹,۰۵۳.۳
                    <span class="text-regualr-5">تومان</span>
                  </div>
                </g-col>
                <g-col :xs="8">
                  <div class="text-regular-6">تسلط به بازار (دامیننس)</div>
                  <div class="text-title-4">۳۶.۴۶%</div>
                </g-col>
                <g-col :xs="8">
                  <div class="text-regular-6">مجموع ارز در دسترس</div>
                  <div class="text-title-4">۲۱,۰۰۰,۰۰۰</div>
                </g-col>
                <g-col :xs="8">
                  <div class="text-regular-6">حجم کل بازار</div>
                  <div class="text-title-4">
                    ۱۲,۵۴۲,۵۶۲,۸۹۳,۲۴۶,۶۷۴
                    <span class="text-regualr-5">تومان</span>
                  </div>
                </g-col>
                <g-col :xs="8">
                  <div class="text-regular-6">ارز در گردش</div>
                  <div class="text-title-4">۸۴.۱۴%</div>
                </g-col>
                <g-col :xs="8">
                  <div class="text-regular-6">حداکثر ارز قابل عرضه</div>
                  <div class="text-title-4">۲۱,۰۰۰,۰۰۰</div>
                </g-col>
              </g-row>
            </div>
          </div>
        </g-col>
        <g-col :xs="8">
          <div class="coin-top-sec__box coin-top-sec__otc-box mb-3">
            <div class="text-title-4 mb-4 color-primary text-center">
              خرید سریع بیت کوین
            </div>
            <idontknow-otc-box>
              <template #action>
                <g-btn class="coin-top-sec__otc-action">تبدیل</g-btn>
              </template>
            </idontknow-otc-box>
          </div>
          <g-row :y-gutter="10" :gutter="10">
            <g-col :xs="12">
              <a href="" target="_blank">
                <div
                  class="coin-top-sec__box coin-top-sec__link color-base text-regular-4"
                >
                  نمودار تحلیل BTC
                </div>
              </a>
            </g-col>
            <g-col :xs="12">
              <a href="" target="_blank">
                <div
                  class="coin-top-sec__box coin-top-sec__link color-base text-regular-4"
                >
                  نمودار تحلیل BTC
                </div>
              </a>
            </g-col>
            <g-col :xs="12">
              <a href="" target="_blank">
                <div
                  class="coin-top-sec__box coin-top-sec__link color-base text-regular-4"
                >
                  نمودار تحلیل BTC
                </div>
              </a>
            </g-col>
            <g-col :xs="12">
              <a href="" target="_blank">
                <div
                  class="coin-top-sec__box coin-top-sec__link color-base text-regular-4"
                >
                  نمودار تحلیل BTC
                </div>
              </a>
            </g-col>
          </g-row>
        </g-col>
      </g-row>
    </div>
  </section>
</template>

<script lang="ts">
export default {
  data() {
    return {
      tradingviewTechnicalOptions: {
        autosize: true,
        symbol: `BINANCE:BTCUSDT`,
        interval: 'H',
        timezone: 'Etc/UTC',
        theme: 'light',
        style: '1',
        locale: 'en_EN',
        enable_publishing: true,
        save_image: false,
        hide_side_toolbar: false,
        container_id: 'tradingview-chart',
        trendLineColor: 'rgba(28, 57, 186, 1)',
        underLineColor: 'rgba(28, 57, 186, 0.2)',
        underLineBottomColor: 'rgba(28, 57, 186, 0)',
        isTransparent: true,
        fullscreen: true,
      },
    }
  },
}
</script>

<style lang="scss" scoped>
.coin-top-sec {
  background-color: $--color-neutral-20;
  padding-bottom: 2rem;
  &__head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 2rem 0;
  }

  &__currency-info {
    display: flex;
    align-items: center;
    img {
      width: 70px;
    }
  }

  &__currency-info-detail {
    margin-right: 10px;
    flex: 1;
  }

  &__box {
    background-color: $--color-white;
    border-radius: $--border-radius-base;
    border: 1px solid $--border-color-2;
    box-shadow: $--box-shadow-1;
  }

  &__chart-head {
    padding: 1.5rem 2rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  &__change {
    color: $--color-success-300;
    svg {
      path {
        stroke: $--color-success-300;
      }
    }
  }
  &__link {
    padding: 0.75rem 0.3rem;
    text-align: center;
  }

  &__chart {
    padding: 20px;
    border-top: 1px solid $--border-color-2;
    border-bottom: 1px solid $--border-color-2;
    height: 407px;
  }
  &__chart-inner {
    height: 100% !important;
  }

  &__detail {
    padding: 1.4rem 3rem;
  }

  &__otc-box {
    padding: 1rem 0.8rem;
  }

  &__otc-action {
    margin-top: 91px;
    width: 100%;
    margin-bottom: 1.2rem;
  }
}
</style>
