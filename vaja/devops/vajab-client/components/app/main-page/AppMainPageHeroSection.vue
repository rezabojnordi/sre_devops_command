<template>
  <div>
    <div class="main-container">
      <g-row class="hero-section" :gutter="50" alignment="center">
        <g-col :xs="12">
          <h1 class="hero-section__title">
            خرید و فروش ارز دیجیتال در
            <span class="color-primary"> صرافی آنلاین وجب </span>
          </h1>

          <p class="hero-section__description">
            جهان در چشم برهم زدنی ، شاهد چیرگی و سیطره ارزهای دیجیتال بر
            بازارهای مالی و معاملاتی خواهد بود، چندان دور نیست روزگاری که شاهد
            منسوخ شدن استفاده از پول های رایج و جایگزینی تمامی آنها با ارز
            دیجیتال خواهیم بود ...
          </p>

          <div class="start-register">
            <g-row :gutter="10">
              <g-col flex-1>
                <g-input
                  placeholder="شماره موبایل همراه خود را وارد کنید"
                  icon="icon-call"
                  class="start-register__input"
                  no-error
                  top-label
                />
              </g-col>
              <g-col>
                <g-btn class="start-register__btn"> شروع کنید </g-btn>
              </g-col>
            </g-row>
          </div>
        </g-col>
        <g-col class="g-row" :xs="12">
          <div class="g-row flex-1" style="position: relative">
            <img
              src="~/assets/images/main-page/otc-coins.png"
              alt="otc images"
              class="otc-container__bg-1"
            />
            <span class="otc-container__bg-2"></span>
            <div class="otc-container">
              <idontknow-mini-box>
                <idontknow-otc-box />
              </idontknow-mini-box>
            </div>
          </div>
        </g-col>
      </g-row>
    </div>
  </div>
</template>

<script></script>

<style lang="scss">
.otc-container {
  margin: auto;
  max-width: 523px;
  width: 100%;
  z-index: 2;
  position: relative;
  &__bg-1 {
    position: absolute;
    top: -2.5rem;
    left: -1rem;
  }
  &__bg-2 {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 264px;
    height: 115px;
    background-color: #edf4f5;
    border-radius: $--border-radius-base;
    transform: translateY(40%);
  }
}
.hero-section {
  min-height: 500px;
  padding-top: 4rem;
  &__title {
    font-weight: 700;
    line-height: 70px;
    font-size: 40px;
    max-width: 416px;
  }
  &__description {
    font-size: 0.9rem;
    line-height: 28px;
    color: $--color-neutral-300;
    margin: 1.3rem 0 1.6rem 0;
  }
}
.start-register {
  &__input {
    .global-input__inner {
      height: 52px;
    }
  }
  &__btn {
    height: 100%;
    width: 140px;
  }
}
</style>
