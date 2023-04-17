<template>
  <div class="download main-container">
    <section class="download__intro">
      <g-row>
        <g-col class="download__intro__img" :xs="8">
          <img
            class="download__intro__img__back"
            src="~/assets/images/download/backapp.svg"
            alt=""
          />
          <img
            class="download__intro__img__front"
            src="~/assets/images/download/application.png"
            alt=""
          />
        </g-col>
        <g-col class="download__intro__content" :xs="16">
          <h2>اپلیکیشن وجب</h2>
          <h3>بستری‌ امن برای ورود به بازار جهانی ارزهای دیجیتال</h3>
          <p>
            جهان در چشم برهم زدنی ، شاهد چیرگی و سیطره ارزهای دیجیتال بر
            بازارهای مالی و معاملاتی خواهد بود، چندان دور نیست روزگاری که شاهد
            منسوخ شدن استفاده از پول های رایج و جایگزینی تمامی آنها با ارز
            دیجیتال خواهیم بود ...
          </p>
          <div class="download__intro__content__link">
            <img src="~/assets/images/download/bazar.png" alt="" />
            <img src="~/assets/images/download/google-play.png" alt="" />
            <img src="~/assets/images/download/apple.png" alt="" />
          </div>
        </g-col>
      </g-row>
    </section>
    <section class="download__benefit">
      <h2 class="text-title-3">چرا از اپلیکیشن وجب استفاده کنیم ؟</h2>
      <g-row>
        <g-col
          v-for="(item, idx) in benefits"
          :key="idx"
          :xs="[0, 3].includes(idx % 4) ? 10 : 14"
        >
          <div class="download__benefit__item">
            <img :src="item.icon" alt="" />
            <div>
              <h3 class="text-title-3">{{ item.title }}</h3>
              <p class="text-regular-4">{{ item.content }}</p>
            </div>
          </div>
        </g-col>
      </g-row>
    </section>
    <section class="download__faq">
      <img
        class="download__faq__back"
        src="~/assets/images/main-page/rectangles.svg"
        alt=""
      />
      <h2 class="text-title-3">سوالات متداول</h2>
      <g-row alignment="center" justify="center">
        <g-col :xs="16">
          <app-faq-expandable-faq
            v-for="qa in content"
            :key="qa.question"
            :answer="qa.answer"
            :question="qa.question"
          ></app-faq-expandable-faq>
        </g-col>
      </g-row>
    </section>
    <section class="download__video">
      <g-row alignment="center" justify="space-between" :gutter="15">
        <g-col :xs="14">
          <h3>راهنمای ویدئویی استفاده از اپلکیشن وجب</h3>
          <div class="scrolled-des">
            <p
              class="scrolled-des__inner text-light text-regular-4 text-justify"
            >
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
              تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد.
              اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای
              دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به
              دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در
              مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس
              با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the
              Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد
              تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند.
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
        </g-col>
        <g-col :xs="10">
          <img src="~/assets/images/download/help.png" alt="" />
        </g-col>
      </g-row>
    </section>
    <section class="download__box">
      <div class="download__box__back"></div>
      <div class="download__box__content">
        <div class="download__box__qrcode">
          <img src="~/assets/images/download/qrcode.svg" alt="" />
        </div>
        <div class="download__box__links">
          <img src="~/assets/images/download/bazar.png" alt="" />
          <img src="~/assets/images/download/google-play.png" alt="" />
          <img src="~/assets/images/download/apple.png" alt="" />
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
const benefits = ref([
  {
    icon: useAssetMedia('/assets/images/download/benefit-1.png'),
    title: 'احراز هویت سریع',
    content:
      'در صرافی وجب، در کمتر از پنج دقیقه ثبت نام و معامله در پرسودترین بازارها را آغاز کنید.',
  },
  {
    icon: useAssetMedia('/assets/images/download/benefit-2.png'),
    title: 'امکانات پیشرفته برای معاملات',
    content:
      'ابزارهای مدرن برای انجام معاملات از جمله حد سود و ضرر، پنل گزارش سود و زیان، امکان تنظیم هشدار قیمت و همچنین نمودارهای قیمتی و ابزارهای تحلیل بازار در اختیار شماست.',
  },
  {
    icon: useAssetMedia('/assets/images/download/benefit-3.png'),
    title: 'سپرهای امنیتی مدرن',
    content:
      'تیم امنیتی پیشرفته وجب با ابزارهای مدرن و به‌روز، همواره برای حفظ امنیت دارایی کاربران تلاش می‌کنند. ذخیره امن دارایی کاربران در کیف پول‌های سرد و تایید هویت دو عاملی از جمله ...',
  },
  {
    icon: useAssetMedia('/assets/images/download/benefit-4.png'),
    title: 'پشتیبانی حرفه‌ای',
    content:
      'پشتیبانی حرفه‌ای و ۲۴ ساعته‌ی آنلاین و تلفنی وجب، خیال کاربران را برای پاسخ به هر سوالی آسوده می‌کند.',
  },
])
const content = ref([
  {
    question: 'بهترین راه خرید بیت کوین چیست ؟',
    answer:
      'تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. ',
  },
  {
    question: 'آیا امکان خرید و فروش بیت کوین بدون پرداخت کارمزد وجود دارد؟',
    answer:
      'تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. ',
  },
  {
    question: 'چگونه می‌توان بیت کوین خریداری کرد؟',
    answer:
      'تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. ',
  },
  {
    question: 'آیا امکان خرید و فروش بیت کوین بدون پرداخت کارمزد وجود دارد؟',
    answer:
      'تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter) با کاربرد بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. ',
  },
])
</script>

<style lang="scss" scoped>
.download {
  display: flex;
  flex-direction: column;
  gap: 6rem;
  padding-top: 0;
  &__intro {
    &__img {
      &__back {
        position: absolute;
        right: 0;
      }
      &__front {
        z-index: 1;
        position: relative;
        margin: 4rem 4rem 0 0;
      }
    }
    &__content {
      align-self: center;
      padding: 4rem;
      h2 {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 0rem;
      }
      h3 {
        color: $--color-primary;
        font-weight: 700;
        font-size: 1.5rem;
        margin: 0;
      }
      &__link {
        display: flex;
        gap: 0.5rem;
      }
    }
  }
  &__benefit {
    &__item {
      padding: 1.5rem;
      margin: 0.5rem;
      background-color: #edf4f5;
      color: red;
      border-radius: $--border-radius-base;
      display: flex;
      align-items: center;
      gap: 2rem;
      h3 {
        color: #45a8c2;
        margin-bottom: 0.8rem;
      }
      p {
        color: #6d6a69;
      }
    }
  }
  &__faq {
    //background-color: green;
    position: relative;
    margin: 0 auto;
    &__back {
      //background-color: red;
      position: absolute;
      transform: scaleX(-1);
    }
    h2 {
      text-align: center;
    }
  }
  &__box {
    &__back {
      background: url('~/assets/images/download/curvback.svg') center center
        no-repeat;
      position: absolute;
      left: 0;
      right: 0;
      height: 16rem;
      transform: translateY(8rem);
    }
    &__content {
      z-index: 1;
      position: relative;
    }

    &__qrcode {
      border: 1px solid $--color-neutral-30;
      border-radius: $--border-radius-base;
      padding: 1.25rem;
      background-color: $--color-white;
      display: flex;
      align-items: center;
      justify-content: center;
      max-width: fit-content;
      margin: 0 auto;
    }
    &__links {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 1rem;
      margin-top: 2rem;
    }
  }
}
</style>
