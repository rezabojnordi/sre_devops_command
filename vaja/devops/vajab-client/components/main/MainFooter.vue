<template>
  <footer class="footer-container">
    <div class="main-container footer-content">
      <!-- website des -->
      <div class="footer-logo">
        <div>
          <img src="~/assets/images/logo-primary.svg" alt="vajab logo" />
        </div>
        <div class="text-regular-4 text-light text-justify">
          تیم بودن و حرفه‌ای بودن، کافی نبود؛ باید یک آرزو تحقق پیدا می‌کرد. اما
          دنبال مسیری به سوی بی‌نهایت بودیم و بازار مالی بخصوص ارزهای دیجیتال
          برایمان مثال یک کوهنوردی بدون قله بود.
        </div>
        <div class="footer-contact">
          <div class="footer-icon color-primary text-regular-2">
            <span class="icon-call-calling"></span>
          </div>
          <div class="footer-contact__context">
            <div class="footer-contact__text">
              <a href="tel:05137057376">
                051<span class="color-base"> - 37057376</span>
              </a>
            </div>
            <div class="text-light text-regular-5">
              شنبه تا پنجشنبه ۹ الی ۱۸
            </div>
          </div>
        </div>
      </div>

      <!-- website items -->
      <div class="footer-content__item-3">
        <div style="display: flex; flex-wrap: wrap">
          <nav class="footer-links" :class="{ 'footer-links--active': acc1 }">
            <div class="footer-links__headline" @click="acc1 = !acc1">
              دسترسی سریع
              <span class="footer-links__head-arrow icon-down"></span>
            </div>
            <ul class="footer-links__links-ul">
              <li>
                <router-link to="/otc">خرید و فروش ارز دیجیتال</router-link>
              </li>
              <li>
                <router-link to="/otc?currency=USDT">خرید تتر</router-link>
              </li>
              <li>
                <router-link to="/otc?currency=USDT&type=sell"
                  >فروش تتر</router-link
                >
              </li>
              <li><router-link to="/download">دانلود اپلیکیشن</router-link></li>
            </ul>
          </nav>

          <nav class="footer-links" :class="{ 'footer-links--active': acc2 }">
            <div class="footer-links__headline" @click="acc2 = !acc2">
              راهنمای استفاده
              <span class="footer-links__head-arrow icon-down"></span>
            </div>

            <ul class="footer-links__links-ul">
              <li>
                <router-link to="/">
                  <a href="https://vajab.ir/blog" target="_blank"
                    >وبلاگ آموزشی</a
                  ></router-link
                >
              </li>
              <li>
                <router-link to="/">
                  <a href="https://vajab.ir/blog" target="_blank"
                    >شیوه های پرداخت</a
                  ></router-link
                >
              </li>
              <li>
                <router-link to="/">
                  <a href="https://vajab.ir/blog" target="_blank"
                    >سوالات متداول</a
                  ></router-link
                >
              </li>
              <li>
                <a href="https://vajab.ir/blog" target="_blank">
                  وبلاگ آموزشی
                </a>
              </li>
            </ul>
          </nav>

          <nav class="footer-links" :class="{ 'footer-links--active': acc3 }">
            <div class="footer-links__headline" @click="acc3 = !acc3">
              درباره وجب
              <span class="footer-links__head-arrow icon-down"></span>
            </div>
            <ul class="footer-links__links-ul">
              <li><router-link to="/about-us">درباره مجموعه</router-link></li>
              <li><router-link to="/contact">تماس با ما</router-link></li>
              <li><router-link to="/policies">قوانین و مقررات</router-link></li>
              <li><span>سطوح کاربری</span></li>
            </ul>
          </nav>
        </div>
      </div>

      <!-- social links -->
      <div class="footer-socials">
        <div class="footer-socials__title text-title-4">ما را دنبال کنید</div>
        <g-row :y-gutter="20" :gutter="20">
          <g-col v-for="(social, i) in socials" :key="i" :xs="8">
            <a :href="social.link" target="_blank" class="footer-icon">
              <span :class="social.icon"></span>
            </a>
          </g-col>
        </g-row>
      </div>
    </div>

    <!-- copy rights -->
    <div class="main-container footer-bottom">
      <div class="footer-bottom__item">
        کلیه حقوق مادی و معنوی این سایت متعلق به وجب می باشد
      </div>
      <div class="footer-bottom__item">
        Copyright © 2022 Vajab.Com. All Right Reserved.
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  data() {
    return {
      acc1: false,
      acc2: false,
      acc3: false,
      socials: [
        {
          link: 'https://t.me/vajab_ir',
          icon: 'icon-telegram',
        },
        {
          link: 'https://www.linkedin.com/company/vajab_ir/',
          icon: 'icon-linkedin',
        },
        {
          link: 'https://twitter.com/vajab_ir/',
          icon: 'icon-twitter',
        },
        {
          link: 'https://www.instagram.com/vajab_ir',
          icon: 'icon-instagram',
        },
        {
          link: 'https://www.aparat.com/vajab_ir/',
          icon: 'icon-aparat',
        },
        {
          link: 'https://google.com',
          icon: 'icon-youtube',
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.footer-container {
  background-color: #f6f6f6;
  padding-top: 3.5rem;
}

.footer-content {
  display: flex;
  flex-wrap: wrap;
  margin: 0 auto;
  padding-top: 4rem;
  padding-bottom: 3rem;
  &__item-1 {
    flex: 1;
    color: white;
    p {
      text-align: justify;
    }
  }

  &__list-nav {
    padding-right: 0;
    max-width: 30rem;
    display: flex;
    justify-content: space-between;
    list-style: none;
  }

  &__item-3 {
    margin-right: 3rem;
    width: 26rem;
  }
  &__item-3 {
    flex: 1;
  }
}

.footer-socials {
  flex: 1;
  max-width: 190px;
  margin-right: auto;
  &__title {
    margin-bottom: 1.5rem;
  }
}

.footer-logo {
  flex: 1;
  max-width: 300px;
  img {
    width: 78px;
    margin-bottom: 1rem;
  }
  &__social {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
  }
}

.footer-icon {
  width: 50px;
  height: 50px;
  border-radius: $--border-radius-small;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: $--color-white;
  box-shadow: $--box-shadow-1;
}

.footer-links {
  display: inline-block;
  padding-right: 1rem;
  // border-right: 1px solid #e2e7f2;
  margin-left: 1rem;
  margin: 0 1rem 0 auto;
  top: 0;
  &__headline {
    margin-bottom: 1.5rem;
    font-weight: 700;
    font-size: 1rem;
    line-height: 28px;
  }
  &__links-ul {
    list-style: none;
    padding: 0;
    color: $--color-neutral-300;
    li {
      font-size: 0.9rem;
      margin-bottom: 0.9rem;
      a {
        color: inherit;
      }
    }
  }
  &__head-arrow {
    display: none;
    font-size: 1rem;
  }
}

.footer-bottom {
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem 0;
  font-size: 0.9rem;
  border-top: 1px solid $--border-color-2;
  color: $--color-neutral-300;
  &__social {
    display: flex;
    justify-content: center;
    align-items: center;
    img {
      margin: 0 0.5rem;
    }
  }
  // &__version{
  //   text-align: left;
  // }
}

.footer-social {
  display: flex;
  justify-content: space-between;
  max-width: 15rem;
  margin: 0.5rem auto 0 auto;
  flex: 0 1 50%;
  margin: 0 0.5rem;
  svg {
    fill: #a4adb4;
    width: 1.8rem;
    height: 1.8rem;
    cursor: pointer;
    transition: fill 0.5s;
    &:hover {
      fill: #f0f0f0;
    }
  }
}
.footer-contact {
  display: flex;
  margin-top: 1.8rem;
  &__context {
    flex: 1;
    margin-right: 0.9rem;
  }
  &__text {
    font-weight: 700;
    font-size: 1.5rem;
    line-height: 28px;
    direction: ltr;
    text-align: right;
  }
}

@media (max-width: 72.5em) {
  .footer-content {
    &__item-3 {
      margin-right: 3rem;
    }
  }
}

@media (max-width: 63.75em) {
  .footer-content {
    &__item-3 {
      margin-right: 1rem;
    }
  }
  .footer-logo {
    &__social {
      display: block;
      margin-top: 0.5rem;
    }
  }
  .footer-social {
    margin: 0.5rem auto;
  }
  .footer-contact {
    margin: 1.5rem 0;
  }
  .footer-socials {
    margin: 0 auto;
    text-align: center;
    &__title {
      margin: 1rem 0;
    }
  }
}

@media (max-width: 61.25em) {
  .footer-logo {
    flex: 1 1 100%;
    max-width: 35rem;
    margin: 0 auto;
  }
  .footer-content {
    img {
      margin: 0 auto;
    }
    &__item-3 {
      flex: 1 1 100%;
    }
  }
  .footer-links {
    flex: 0 0 50%;
    padding: 0;
    margin: 0;
  }
}

@media (max-width: 57.5em) {
  .footer-content {
    &__item-3 {
      margin-right: 0;
    }
  }
}

@media (max-width: 37.5em) {
  .footer-content {
    padding-top: 2rem;
    padding-bottom: 1rem;
  }
  .footer-container {
    padding-bottom: 0;
  }
}
@media (max-width: 37.5em) {
  .footer-content {
    &__item-1 {
      p {
        font-size: 0.8rem;
      }
    }

    &__list-nav {
      font-size: 0.8rem;
    }
    &__item-3 {
      margin-right: 0;
      flex: 1 1 100%;
    }
  }
  .footer-bottom {
    justify-content: center;
    flex-wrap: wrap;
    &__copy-right {
      flex: 1 1 100%;
      font-weight: bold;
      color: white;
      font-size: 0.8rem;
    }
    &__social {
      img {
        margin: 0 0.5rem;
      }
    }
    // &__version{
    //   text-align: left;
    // }
  }
  .footer-links {
    flex: 0 0 100%;
    margin: 0.5rem 0;
    &__headline {
      font-size: 0.95rem;
      margin-bottom: 0.5rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    &__links-ul {
      margin: 0;
      height: 0;
      overflow: hidden;
      transition: all 0.3s;
      li {
        font-size: 0.9rem;
        margin: 0.5rem 0;
      }
    }
    &__head-arrow {
      display: block;
      transition: all 0.3s;
    }
  }
  .footer-links--active {
    .footer-links {
      &__links-ul {
        height: 100px;
      }
      &__head-arrow {
        transform: rotate(180deg);
      }
    }
  }
}
</style>
