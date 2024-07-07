<template>
  <header class="header-outer">
    <div class="header-outer__toggle-btn">
      <div class="header-outer__toggle-btn-box" @click="handleDrawer()">
        <span class="icon-arrow-square-left"></span>
      </div>
    </div>
    <div class="header">
      <div class="header__m-nav sm-item" @click="handleDrawer()">
        <span class="icon-nav-menu"></span>
      </div>
      <div class="header__sec-1">
        <nuxt-link to="/">
          <div class="header__logo">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="78"
              height="32"
              viewBox="0 0 78 32"
              fill="none"
            >
              <path
                d="M57.2555 31.9878C57.2188 31.9878 57.1822 31.9931 57.1455 31.9931C55.9872 31.9931 54.8289 31.9931 53.6707 31.9983C53.5029 31.9983 53.4872 31.9668 53.5711 31.8248C54.1476 30.8466 54.7136 29.8579 55.2796 28.8745C55.3373 28.7693 55.3845 28.6852 55.4788 28.8535C56.0658 29.879 56.6633 30.9045 57.2555 31.93C57.2555 31.9405 57.2503 31.9615 57.2555 31.9878Z"
                fill="#45A8C2"
              />
              <path
                d="M25.7243 31.9983C24.4761 31.9983 23.2384 31.9983 21.9902 31.9983C22.0006 31.9614 22.0058 31.9297 22.0214 31.9033C22.5987 30.8951 23.176 29.887 23.748 28.8788C23.8157 28.7574 23.8573 28.6888 23.9561 28.8629C24.5333 29.8869 25.121 30.9057 25.7035 31.9297C25.7139 31.9455 25.7139 31.9614 25.7243 31.9983Z"
                fill="#45A8C2"
              />
              <path
                d="M72.1486 30.0154C72.5448 30.2678 72.6602 30.6491 72.5849 31.1056C72.5147 31.5513 72.2238 31.7822 71.8426 31.9004C71.336 32.0615 70.8144 31.9702 70.3028 31.9809C70.1774 31.9863 70.1172 31.8789 70.1172 31.75C70.1172 30.6921 70.1172 29.6341 70.1172 28.5762C70.1172 28.4527 70.1824 28.3667 70.2978 28.3667C70.7391 28.3721 71.1805 28.3077 71.6119 28.4097C72.3993 28.603 72.6401 29.3012 72.1486 30.0154ZM70.6338 30.9123C70.6338 31.0573 70.6338 31.2023 70.6338 31.3526C70.6338 31.4117 70.6137 31.4923 70.709 31.4923C71.0652 31.4869 71.4213 31.5406 71.7623 31.3848C71.973 31.2936 72.0834 31.1217 72.0834 30.8747C72.0783 30.633 71.9479 30.4934 71.7423 30.4128C71.5617 30.343 71.3761 30.3269 71.1855 30.3269C70.6338 30.3323 70.6338 30.3269 70.6338 30.9123ZM70.6338 29.3441C70.6338 29.4677 70.6338 29.5858 70.6338 29.7093C70.6338 29.7845 70.6438 29.8328 70.7291 29.8328C71.015 29.8328 71.3059 29.8436 71.5818 29.7469C71.7774 29.6771 71.8727 29.5375 71.8677 29.3065C71.8576 29.081 71.7272 28.9682 71.5517 28.9199C71.4062 28.8823 71.2507 28.8662 71.1053 28.8608C70.6338 28.8554 70.6338 28.8608 70.6338 29.3441Z"
                fill="#45A8C2"
              />
              <path
                d="M9.12857 28.7656C8.87759 29.2129 8.64709 29.6234 8.41147 30.0339C8.06317 30.6549 7.70974 31.2706 7.36143 31.8916C7.29485 32.0127 7.24875 32.0495 7.16679 31.9022C6.58799 30.8707 6.00407 29.8392 5.39453 28.7656C5.64552 28.7656 5.86065 28.7656 6.0809 28.7656C6.18334 28.7656 6.19871 28.8603 6.23456 28.9235C6.53165 29.4445 6.82873 29.9707 7.12069 30.4917C7.15655 30.5602 7.20265 30.6233 7.25899 30.7233C7.469 30.3602 7.66364 30.0181 7.85316 29.676C7.98633 29.4445 8.12975 29.2129 8.24244 28.9708C8.32439 28.8024 8.43196 28.7445 8.60611 28.7603C8.77515 28.7761 8.92881 28.7656 9.12857 28.7656Z"
                fill="#45A8C2"
              />
              <path
                d="M40.6482 30.0004C40.6219 30.3347 40.6955 30.7338 40.5956 31.1329C40.4589 31.6568 40.1277 31.9362 39.5705 31.991C38.9765 32.0459 38.4298 31.7865 38.2038 31.3524C38.1197 31.1928 38.2038 31.123 38.3299 31.0481C38.5087 30.9384 38.6716 30.9184 38.803 31.098C38.966 31.3225 39.1815 31.4223 39.4759 31.4023C39.7177 31.3874 39.8544 31.2726 39.928 31.0681C39.9911 30.8935 39.9806 30.7089 39.9858 30.5293C39.9858 30.0304 39.9858 29.5315 39.9858 29.0326C39.9858 28.7931 40.0331 28.7681 40.3328 28.7582C40.543 28.7532 40.6692 28.7981 40.6587 29.0326C40.6376 29.3319 40.6482 29.6312 40.6482 30.0004Z"
                fill="#45A8C2"
              />
              <path
                d="M74.5444 3.32054C72.2868 1.12123 69.5608 0.0138447 66.377 0.0086941C61.6828 0.00354349 56.9834 0.00869536 52.2893 0.00354475C52.1209 0.00354475 51.9578 0.00869159 51.7894 0.0189928C51.4105 0.0344447 51.0316 0.0756508 50.6527 0.142609C47.1321 0.765833 44.6271 4.294 45.2534 7.73461C45.8059 10.7683 48.1688 12.9367 51.1947 13.3024C51.5368 13.3488 51.8841 13.3745 52.2419 13.3745C51.6946 13.3797 51.521 13.3848 53.2523 13.3848C53.9312 13.3848 54.6048 13.3951 55.2837 13.3797C55.3152 13.3797 55.3416 13.3745 55.3731 13.3745C58.6464 13.3745 61.9197 13.3745 65.1929 13.3745C65.8718 13.3745 66.5506 13.3848 67.2295 13.3694C68.1978 13.3488 68.8714 12.4526 68.6188 11.5409C68.4346 10.8765 67.861 10.4799 67.0874 10.4799C62.6564 10.4799 58.2254 10.4799 53.7944 10.4799C54.0786 10.4747 54.0049 10.4696 51.9788 10.4644C51.8788 10.4644 51.7788 10.4593 51.6841 10.449C49.7738 10.2275 48.253 8.58962 48.253 6.67359C48.2582 4.62364 49.937 2.94454 52.0367 2.89819C56.794 2.89304 61.5513 2.89819 66.3138 2.89304C67.2295 2.89304 68.1189 3.03726 68.9819 3.32569C73.3077 4.75756 75.7758 9.36735 74.5812 13.7711C73.555 17.5671 70.0976 20.1836 66.1191 20.163C60.8935 20.1321 55.6731 20.1424 50.4474 20.1527C48.8213 20.1527 47.3952 20.1476 46.3427 20.1476C46.1901 20.1218 46.0901 20.0497 46.0006 19.8901C45.5165 19.0402 45.0113 18.2058 44.5114 17.3663C43.2536 15.2597 40.4224 15.2545 39.1647 17.3611C38.67 18.1904 38.1753 19.0196 37.6912 19.8592C37.5649 20.0806 37.4281 20.163 37.1597 20.163C32.8234 20.1527 28.4871 20.1579 24.1455 20.1579C19.9198 20.1579 15.6887 20.1579 11.463 20.1579C10.3894 20.1579 9.35796 19.9416 8.37388 19.5398C4.527 17.9637 2.26413 13.8638 3.13244 9.86182C3.91655 6.24609 6.1689 3.94376 9.87369 3.06301C10.742 2.85699 11.6314 2.90334 12.5155 2.89819C13.3154 2.88789 13.9521 2.26466 13.9732 1.49207C13.9889 0.729782 13.3996 0.0550471 12.626 0.0189928C10.6736 -0.0737182 8.77383 0.16321 6.96353 0.946103C1.77472 3.19177 -1.06176 8.95531 0.369641 14.3738C1.70631 19.4471 6.23731 23.0268 11.4103 23.0371C20.5881 23.0577 29.7659 23.0422 38.9436 23.0474C39.1489 23.0474 39.2489 22.9804 39.3489 22.8105C40.1014 21.5228 40.8697 20.2403 41.6328 18.9578C41.838 18.6127 41.838 18.6127 42.0327 18.9475C42.7958 20.23 43.5588 21.5125 44.3114 22.8002C44.3482 22.8671 44.3903 22.9135 44.4324 22.9547V23.0886C44.4324 23.0886 59.3147 23.0886 66.5401 23.0783C68.5135 23.0783 70.3659 22.5838 72.0815 21.6258C78.8017 17.8762 80.0437 8.67718 74.5444 3.32054Z"
                fill="#45A8C2"
              />
            </svg>
          </div>
        </nuxt-link>
        <div class="header__routes header__sec-1">
          <nuxt-link to="/otc">
            <div class="header__item">معامله سریع</div>
          </nuxt-link>
          <a href="https://blog.vajab.ir" target="_blank">
            <div class="header__item">بلاگ</div>
          </a>
          <div class="header__item">
            <utilities-menu-dropdown :top-margin="34" min-width="190px">
              <template #title>
                سایر
                <span class="mx-2 vertical-middle icon-down"></span>
              </template>
              <template #body>
                <nuxt-link
                  v-for="(item, i) in otherPages"
                  :key="i"
                  :to="item.to"
                >
                  <div class="dropdown-item">
                    <span>
                      {{ item.text }}
                    </span>
                    <span class="dropdown-item__arrow icon-left"></span>
                  </div>
                </nuxt-link>
              </template>
            </utilities-menu-dropdown>
          </div>
        </div>
      </div>
      <div class="header__sec-2">
        <div
          class="header__action"
          @mouseover="showNotification = true"
          @mouseleave="showNotification = false"
        >
          <span class="icon-notification"></span>
          <transition>
            <main-header-notification-box
              v-if="showNotification"
            ></main-header-notification-box>
          </transition>
        </div>
        <!-- <div class="header__action">
          <span class="icon-moon"></span>
        </div> -->

        <div
          class="header__action header__download"
          @mouseover="showDownloadBox = true"
          @mouseleave="showDownloadBox = false"
        >
          <g-btn :outlined="true">دانلود اپلیکیشن</g-btn>
          <transition name="fade" mode="out-in">
            <div v-if="showDownloadBox" class="header__download__box">
              <div class="header__download__box__inner">
                <img src="~/assets/images/download/qrcode.svg" alt="" />
                <span class="text-regular-5">vajab.ir/download</span>
                <img src="~/assets/images/download/google-play.png" alt="" />
                <img src="~/assets/images/download/bazar.png" />
                <img src="~/assets/images/download/apple.png" />
              </div>
            </div>
          </transition>
        </div>

        <div class="header__action">
          <router-link to="/login">
            <g-btn> ورود/ثبت نام </g-btn>
          </router-link>
        </div>
      </div>
    </div>
  </header>
</template>

<script lang="ts">
import { appStore } from '@/stores/app'
import { mapWritableState } from 'pinia'

export default {
  data() {
    return {
      otherPages: [
        {
          text: 'قوانین و کارمزدها',
          to: '/policies',
        },
        {
          text: 'درباره ما',
          to: '/about-us',
        },
        {
          text: 'راهنما',
          to: '/account',
        },
        {
          text: 'درخواست ها',
          to: '/support/ticketing',
        },
      ],
      showDownloadBox: false,
      showNotification: false,
    }
  },
  computed: {
    ...mapWritableState(appStore, ['drawer']),
  },
  methods: {
    handleDrawer() {
      if (this.$route.path.split('/')[1] != 'account') {
        this.$router.push('/account')
        this.drawer = true
      } else {
        this.drawer = !this.drawer
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.header-outer {
  display: flex;
  height: 90px;
  &__toggle-btn {
    width: 70px;
    background-color: #d3e6eb;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  &__toggle-btn-box {
    background-color: #9acddb;
    border-radius: 0.5rem;
    width: 1.6rem;
    height: 1.6rem;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $--color-primary;
    font-size: 1.5rem;
    cursor: pointer;
  }
}

.header {
  flex: 1;
  display: flex;
  justify-content: space-between;
  padding: 1.2rem 1rem;
  background: $--color-white;
  box-shadow: -10px 0px 8px rgba(26, 26, 26, 0.12);
  z-index: 2;
  &__download__box {
    position: absolute;
    left: 0;
    right: 0;
    top: 100%;
    padding: 1rem 0;
    &__inner {
      background-color: $--color-white;
      border: 1px solid $--color-neutral-30;
      border-radius: $--border-radius-base;
      box-shadow: $--box-shadow-4;
      padding: 1rem;
      text-align: center;
      > * {
        width: 100%;
      }
    }
  }
  &__sec-1 {
    display: flex;
    align-items: center;
  }
  &__logo {
    width: 70px;
    display: flex;
    align-items: center;
    svg {
      width: 100%;
    }
    margin: 0 1rem 0 2.2rem;
  }
  &__item {
    padding: 0 1rem;
    color: $--color-neutral-900;
    font-size: 0.9rem;
  }
  &__sec-2 {
    display: flex;
    align-items: center;
  }
  &__action {
    display: flex;
    flex-direction: column;
    align-items: center;
    cursor: pointer;
    position: relative;
    color: $--color-neutral-500;
    z-index: 100;
    button {
      padding: 0 2rem;
    }
    margin: 0 0.7rem;
    &:last-of-type {
      margin: 0;
    }
  }
}

.dropdown-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: $--color-neutral-900;
  line-height: 1.5rem;
  padding: 0.5rem 0.7rem;
  font-size: 0.9rem;
  transition: all 0.2s;
  &:hover {
    color: $--color-primary;
  }
}

.router-link-exact-active {
  .dropdown-item {
    color: $--color-primary;
    background-color: $__color-secondary-50;
    border-radius: 0.5rem;
  }
}

@media (max-width: 53.2em) {
  .header-outer {
    height: 75px;
    &__toggle-btn {
      width: 60px;
    }
    &__toggle-btn-box {
      width: 1.5rem;
      height: 1.5rem;
    }
  }

  .header {
    &__logo {
      width: 60px;
      margin: 0 0.8rem 0 1.5rem;
    }
    &__item {
      padding: 0 0.8rem;
    }
    &__action {
      button {
        padding: 0 1rem;
      }
    }
  }
}

@media (max-width: 48em) {
  .header-outer {
    height: 60px;
    &__toggle-btn {
      display: none;
    }
  }
  .header {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: space-between;
    &__routes {
      display: none;
    }
    &__download {
      display: none;
    }
    &__action {
      button {
        font-size: 0.7rem;
        padding: 0 0.5rem;
        min-width: auto;
      }
    }
    &__m-nav {
      font-size: 1.5rem;
    }
    &__sec-1 {
      position: absolute;
      right: 50%;
      top: 50%;
      transform: translate(50%, -50%);
    }
    &__logo {
      width: 50px;
    }
  }
}
</style>
