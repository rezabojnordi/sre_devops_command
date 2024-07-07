<template>
  <div>
    <div class="blog-post-list">
      <div class="blog-post-list__bg"></div>
      <div class="main-inner-container">
        <div class="g-justify-space-between g-align-center g-row mb-4">
          <h3 class="text-title-3 my-0">از وبلاگ وجب چه خبر ؟</h3>
          <a href="https://blog.vajab.ir" target="_blank">
            <div class="color-primary">
              <span class="mx-2 text-title-4">مشاهده همه</span>
              <span class="icon-arrow-left vertical-middle"></span>
            </div>
          </a>
        </div>
        <ClientOnly>
          <div class="slider-outer">
            <span
              class="slide-change-btn slide-next icon-arrow-left"
              @click="sInstance.slideNext()"
            ></span>
            <span
              class="slide-change-btn slide-prev icon-arrow-left"
              @click="sInstance.slidePrev()"
            ></span>
            <swiper
              ref="s"
              :pagination="{ clickable: true }"
              :modules="modules"
              :slides-per-view="3"
              :space-between="32"
              :autoplay="autoplay"
              loop
              class="swiper"
              @swiper="setSwiperInstance"
            >
              <swiper-slide v-for="i in 6" :key="i">
                <div class="blog-item">
                  <img
                    src="~/assets/images/main-page/blog-post.png"
                    alt="blog post alt"
                  />
                  <div class="blog-item__bottom text-title-5">
                    تراست ولت چیست؟ آموزش کیف پول Trust wallet
                  </div>
                </div>
              </swiper-slide>
            </swiper>
          </div>
        </ClientOnly>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
// Import Swiper Vue.js components
import { Swiper, SwiperSlide, useSwiper } from 'swiper/vue'
import swiper, { Autoplay, Pagination } from 'swiper'
// Import Swiper styles
import 'swiper/css'
import 'swiper/css/autoplay'
import 'swiper/css/pagination'

export default {
  components: {
    Swiper,
    SwiperSlide,
  },
  setup() {
    const swiper = useSwiper()
    return {
      swiper,
    }
  },
  data() {
    return {
      sInstance: null,
      activeIndex: 0,
      autoplay: {
        delay: 4000,
        disableOnInteraction: false,
      },
      modules: [Autoplay, Pagination],
    }
  },
  methods: {
    setSwiperInstance(s: any) {
      this.sInstance = s
    },
  },
}
</script>

<style lang="scss">
.slider-outer {
  position: relative;
}
.slide-change-btn {
  box-shadow: $--box-shadow-1;
  border-radius: $--border-radius-base;
  background-color: $--color-white;
  display: flex;
  align-items: center;
  justify-content: center;
  color: $--color-primary;
  width: 38px;
  height: 38px;
  cursor: pointer;
}

.slide-next {
  position: absolute;
  top: 50%;
  left: 0;
  transform: translate(calc(-100% - 2rem), -70%);
}

.slide-prev {
  position: absolute;
  top: 50%;
  right: 0;
  transform: translate(calc(100% + 2rem), -70%) rotate(-180deg);
}

.blog-post-list {
  padding-bottom: 1.5rem;
  position: relative;
  &__bg {
    position: absolute;
    right: 0;
    height: 70%;
    bottom: 0;
    left: 22%;
    background-color: $--color-primary-50;
    border-bottom-left-radius: $--border-radius-base;
    border-top-left-radius: $--border-radius-base;
  }
  .swiper {
    padding-bottom: 2rem;
  }
  .swiper-pagination {
    margin-bottom: -1rem !important;
  }
}

.blog-item {
  border-radius: $--border-radius-base;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  img {
    width: 100%;
  }
  &__bottom {
    padding: 1rem 0.5rem;
    text-align: center;
    background-color: $--color-white;
  }
}
</style>
