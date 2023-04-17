<template>
  <div>
    <div class="main-inner-container">
      <div class="start-register">
        <div class="start-register__context">
          <div class="start-register__title">برای شروع آماده اید ؟</div>
          <div class="start-register__des">
            جهان در چشم برهم زدنی ، شاهد چیرگی و سیطره ارزهای دیجیتال بر
            بازارهای مالی و معاملاتی خواهد بود، چندان دور نیست روزگاری که شاهد
            منسوخ شدن استفاده از پول های رایج و جایگزینی تمامی آنها با ارز
            دیجیتال خواهیم بود ...
          </div>
          <div class="text-center">
            <router-link to="/login">
              <g-btn class="start-register__btn"> ثبت نام </g-btn>
            </router-link>
          </div>
        </div>
        <img
          src="~/assets/images/main-page/coins.png"
          alt="coin icon"
          class="start-register__icon-1"
        />
        <img
          src="~/assets/images/main-page/rectangles.svg"
          alt="rectangles icon"
          class="start-register__icon-2"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
export default {}
</script>

<style lang="scss" scoped>
.start-register {
  position: relative;
  &::before {
    content: ' ';
    background-color: $--color-primary-50;
    border-radius: $--border-radius-base;
    display: block;
    position: absolute;
    z-index: -1;
    top: 0.9rem;
    right: 0;
    bottom: 0.9rem;
    left: 0;
  }
  &__context {
    border: 1px solid $--border-color-2;
    box-shadow: 0px 10px 50px rgba(35, 131, 157, 0.1);
    border-radius: $--border-radius-base;
    background-color: $--color-white;
    padding: 34px 44px;
    max-width: 48.5rem;
    margin: 0 auto;
    text-align: center;
  }
  &__title {
    font-weight: 700;
    font-size: 1.5rem;
    line-height: 2.25rem;
  }
  &__des {
    color: $--color-neutral-300;
    font-size: 0.9rem;
    line-height: 28px;
    margin-bottom: $--border-radius-base;
    margin: 1.3rem 0;
  }
  &__btn {
    width: 100%;
    max-width: 141px;
  }
  &__icon-1 {
    width: 95px;
    position: absolute;
    bottom: 0;
    right: 0;
    transform: translate(3.5rem, 1rem);
  }
  &__icon-2 {
    width: 102px;
    position: absolute;
    top: 0;
    left: 0;
    transform: translate(-4.5rem, -3.5rem);
  }
}
</style>
