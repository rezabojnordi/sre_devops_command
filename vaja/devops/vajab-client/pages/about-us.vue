<template>
  <div>
    <div class="about-us main-container">
      <g-row>
        <g-col flex-1>
          <div class="about-us__top-content">
            <h1 class="text-title-3">درباره وجب بیشتر بدانید</h1>
            <p class="text-regualar-5 text-light text-justify">
              تیم وجب (شرکت وجب گستران شرق سازه ) متشکل از جمعی از دانشجویان
              دانشگاه شریف و تهران است که در زمینه‌های گوناگون اعم از برنامه
              نویسی، مدیریت و مالی تخصص دارند. افراد این تیم در چند سال اخیر، در
              خرید و فروش بیت‌کوین و سایر ارزهای دیجیتال فعال بوده‌اند. ما از
              نزدیک شاهد برخی مشکلات برای ایرانیان از جمله دسترسی سخت به
              بازارهای خارجی، وجود کلاهبرداران داخلی، خرید و فروش با سودی
              ناعادلانه برای مردم توسط صرافی‌های داخلی و از طرفی جود نداشتن
              پلتفرمی امن و حرفه‌ای برای خرید و فروش بیت‌کوین و سایر ارزهای
              دیجیتال در ایران و دلایل متعدد دیگر بوده‌ایم. ما با مشاهده این
              مشکلات تصمیم به ایجاد پلتفرمی کاملا ایمن، حرفه‌ای وآسان برای خرید
              و فروش بیت‌کوین و سایر ارزهای دیجیتال گرفتیم. امیدواریم که بتوانیم
              با تلاش بسیار و نوآوری محصولی شایسته شما ارائه نماییم.
            </p>
          </div>
        </g-col>
        <g-col class="g-row">
          <img
            src="~/assets/images/about-us/vajab.png"
            alt="vajab logo"
            class="about-us__top-img"
          />
        </g-col>
      </g-row>

      <div class="about-us__statistics">
        <h2 class="text-title-3 mb-4 text-center">آمار و ارقام صرافی وجب</h2>
        <g-row :gutter="30">
          <g-col v-for="(item, i) in statistics" :key="i" :xs="6">
            <div class="statistics-card">
              <div class="statistics-card__value">{{ item.value }}</div>
              <div class="text-light statistics-card__text">
                {{ item.text }}
              </div>
            </div>
          </g-col>
        </g-row>
      </div>

      <g-row>
        <g-col class="g-row">
          <img
            src="~/assets/images/about-us/vajab-supporters.png"
            alt="vajab supporters"
            class="about-us__bottom-img"
          />
        </g-col>
        <g-col flex-1>
          <div class="about-us__bottom-content">
            <h3 class="text-title-3">چرا وجب ؟</h3>
            <p class="text-regualar-5 text-light text-justify">
              تیم وجب (شرکت وجب گستران شرق سازه ) متشکل از جمعی از دانشجویان
              دانشگاه شریف و تهران است که در زمینه‌های گوناگون اعم از برنامه
              نویسی، مدیریت و مالی تخصص دارند. افراد این تیم در چند سال اخیر، در
              خرید و فروش بیت‌کوین و سایر ارزهای دیجیتال فعال بوده‌اند. ما از
              نزدیک شاهد برخی مشکلات برای ایرانیان از جمله دسترسی سخت به
              بازارهای خارجی، وجود کلاهبرداران داخلی، خرید و فروش با سودی
              ناعادلانه برای مردم توسط صرافی‌های داخلی و از طرفی جود نداشتن
              پلتفرمی امن و حرفه‌ای برای خرید و فروش بیت‌کوین و سایر ارزهای
              دیجیتال در ایران و دلایل متعدد دیگر بوده‌ایم. ما با مشاهده این
              مشکلات تصمیم به ایجاد پلتفرمی کاملا ایمن، حرفه‌ای وآسان برای خرید
              و فروش بیت‌کوین و سایر ارزهای دیجیتال گرفتیم. امیدواریم که بتوانیم
              با تلاش بسیار و نوآوری محصولی شایسته شما ارائه نماییم.
            </p>
          </div>
        </g-col>
      </g-row>

      <section class="landing-item"><app-main-page-start-register /></section>

      <section class="landing-item main-inner-container">
        <h3 class="text-title-3">خرید و فروش مطمئن ارز دیجیتال در صرافی وجب</h3>
        <div class="scrolled-des">
          <div
            class="scrolled-des__inner text-light text-regular-4 text-justify"
          >
            تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
            اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
            دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا
            آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل
            واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق
            یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter)
            با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران
            راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. تیم بودن و
            حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال
            مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال
            برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد.
          </div>
        </div>
      </section>
    </div>
  </div>
</template>
<script setup lang="ts">
const statistics = ref([
  {
    text: 'کاربران وجب',
    value: '+ 23K',
  },
  {
    text: 'کل سفارشات',
    value: '+ 1M',
  },
  {
    text: 'ارز های پشتیبانی شده',
    value: '+12',
  },
  {
    text: 'تیکت های پاسخ داده شده',
    value: '+839',
  },
])
</script>

<style lang="scss" scoped>
.about-us {
  margin-top: 4rem;
  &__top-img {
    margin: auto 0;
    height: auto;
    width: 377px;
  }
  &__top-content {
    margin-left: 180px;
  }
  &__bottom-img {
    margin: auto 0;
    height: auto;
    width: 456px;
  }
  &__bottom-content {
    margin-right: 97px;
  }
  &__statistics {
    margin: 136px 0 76px 0;
  }
}

.statistics-card {
  border-radius: $--border-radius-base;
  background-color: #edf4f5;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 2rem 1rem;
  &__value {
    color: $--color-primary;
    font-weight: 700;
    font-size: 2rem;
    line-height: 56px;
    direction: ltr;
  }
}
</style>
