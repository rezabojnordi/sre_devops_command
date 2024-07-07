<template>
  <div>
    <div class="main-inner-container capa-outer">
      <g-row alignment="center" :gutter="140">
        <g-col flex-1>
          <div class="capa-context">
            <h2 class="capa-context__title text-title-3">
              خرید انواع محصولات و خدمات با ارز دیجیتال
            </h2>
            <p class="capa-context__des text-light text-regular-5 text-justify">
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود.
            </p>
          </div>
          <div class="capa-items">
            <g-row :gutter="29">
              <g-col v-for="(item, i) in items" :key="i" :xs="6">
                <div class="capa-items__item">
                  <img
                    :src="item.icon"
                    :alt="item.text"
                    class="capa-items__item-img"
                  />
                  <div class="text-title-6">
                    {{ item.text }}
                  </div>
                </div>
              </g-col>
            </g-row>
          </div>
        </g-col>

        <g-col class="g-row">
          <img
            src="~/assets/images/main-page/crypto-services.png"
            alt="crypto services"
            class="capa-img-1"
          />
        </g-col>
      </g-row>

      <g-row alignment="center" class="mt-5" :gutter="222">
        <g-col class="g-row">
          <img
            src="~/assets/images/main-page/payment.png"
            alt="payment"
            class="capa-img-2"
          />
        </g-col>

        <g-col flex-1>
          <div class="capa-context capa-context-2">
            <h2 class="capa-context__title text-title-3">
              انجام کلیه پرداخت های ارزی
            </h2>
            <p
              class="capa-context__des-2 text-light text-regular-5 text-justify"
            >
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
            </p>
          </div>
          <g-row class="pt-2" :gutter="20">
            <g-col>
              <g-btn style="width: 144px" type="primary" outlined>
                ثبت درخواست
              </g-btn>
            </g-col>

            <g-col>
              <g-btn style="width: 144px" type="primary"> اطلاعات بیشتر </g-btn>
            </g-col>
          </g-row>
        </g-col>
      </g-row>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      items: [
        {
          icon: new URL(
            '@/assets/images/main-page/buy-ticket.svg',
            import.meta.url
          ),
          text: 'خرید بیلط هواپیما',
        },
        {
          icon: new URL(
            '@/assets/images/main-page/buy-internet.svg',
            import.meta.url
          ),
          text: 'بسته اینترنت و شارژ',
        },
        {
          icon: new URL(
            '@/assets/images/main-page/pay-bills.svg',
            import.meta.url
          ),
          text: 'پرداخت کلیه قبوض',
        },
        {
          icon: new URL(
            '@/assets/images/main-page/online-services.svg',
            import.meta.url
          ),
          text: 'خرید خدمات آنلاین',
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.capa-context {
  margin-top: 1.3rem;
  &__title {
    margin-bottom: 1.4rem;
  }
  &__des {
    margin-bottom: 1.5rem;
  }
}
.capa-context-2 {
  margin-top: 7rem;
}
.capa-img-1 {
  width: 21.875rem;
}

.capa-img-2 {
  width: 25.0625rem;
}

.capa-items {
  position: relative;
  padding: 1.5rem 0;
  &::before {
    content: ' ';
    display: block;
    position: absolute;
    top: 0;
    right: 1.6rem;
    bottom: 0;
    left: 1.6rem;
    background-color: $--color-primary-50;
    border-radius: $--border-radius-base;
    z-index: -1;
  }
  &__item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    border-radius: $--border-radius-base;
    border: 1px solid $--border-color-2;
    background-color: $--color-white;
    height: 162px;
    padding: 1rem 0.5rem;
    box-shadow: $--box-shadow-1;
  }
  &__item-img {
    width: 45px;
    height: 45px;
    margin-bottom: 1.25rem;
  }
}
</style>
