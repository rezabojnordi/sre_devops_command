<template>
  <div>
    <section><app-main-page-hero-section /></section>

    <section>
      <div class="main-slider mt-5">
        <div class="main-slider__bg"></div>
        <app-main-page-slider />
      </div>
    </section>

    <section class="landing-item"><app-main-page-capabilities /></section>

    <section class="landing-item"><app-main-page-why-us /></section>

    <section class="landing-item">
      <app-main-page-video-section
        title="درباره صرافی وجب"
        description="تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی ل سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، های معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجاین شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا تصمیمات پُر سود بگیرند. تer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند."
      />
    </section>

    <section class="download-section landing-item">
      <app-main-page-download-section />
    </section>

    <section class="landing-item"><app-main-page-blog-section /></section>

    <section class="landing-item"><app-main-page-start-register /></section>

    <section class="landing-item main-inner-container">
      <h3 class="text-title-3">خرید و فروش مطمئن ارز دیجیتال در صرافی وجب</h3>
      <div class="scrolled-des">
        <div class="scrolled-des__inner text-light text-regular-4 text-justify">
          تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما
          دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال
          برایمان مثال یک کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا
          کمی متفاوت‌تر و در عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های
          بازار قرار دهیم تا تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی
          جدید، تعریف جدیدی از صرافی‌های OTC (over the Counter) با کاربرد
          بازارهای معاملاتی P2P (peer to peer) ارائه داد تا کاربران راحت‌تر،
          سریع‌تر و ارزان‌تر از قبل خرید و فروش کنند. تیم بودن و حرفه‌ای بودن،
          کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما دنبال مسیری به سوی
          بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال برایمان مثال یک
          کوهنوردی بدون قله بود. این شد که وجب به دنیا آمد تا کمی متفاوت‌تر و در
          عین حال سریع‌تر، معامله‌گران را در مقابل واکنش‌های بازار قرار دهیم تا
          تصمیمات پُر سود بگیرند. توایکس با خلق یک زمین بازی جدید، تعریف جدیدی
          از صرافی‌های OTC (over the Counter) با کاربرد بازارهای معاملاتی P2P
          (peer to peer) ارائه داد تا کاربران راحت‌تر، سریع‌تر و ارزان‌تر از قبل
          خرید و فروش کنند. تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو
          تحقق پیدا می‌کرد. اما دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts"></script>

<style lang="scss">
.landing-item {
  margin-top: 6.5rem;
}

.download-section {
  z-index: 1;
}

.main-slider {
  position: relative;
  &__bg {
    position: absolute;
    left: 0;
    height: 60%;
    bottom: 0;
    right: 22%;
    background-color: $--color-primary-50;
  }
}

.scrolled-des {
  overflow-y: auto;
  max-height: 140px;
  direction: ltr;
  line-height: 28px;
  padding-right: 0.9rem;
  &__inner {
    direction: rtl;
  }
  &::-webkit-scrollbar-thumb {
    border-radius: 8px;
    -webkit-box-shadow: inset 0 0 10rem$--color-primary;
    background-color: transparent;
    position: relative;
    transform: all 0.2s;
    cursor: pointer;
  }

  &::-webkit-scrollbar-track {
    background-color: #f4f4f4;
    border-radius: 0.8rem;
  }

  &::-webkit-scrollbar {
    display: inline-block;
    width: 5px;
    background-color: transparent;
  }
}
</style>
