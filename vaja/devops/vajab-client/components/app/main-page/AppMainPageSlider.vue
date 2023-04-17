<template>
  <div>
    <div class="main-container">
      <ClientOnly>
        <swiper
          dir="rtl"
          :pagination="{ clickable: true }"
          :modules="modules"
          :slides-per-view="3"
          :space-between="32"
          :navigation="true"
          loop
          class="swiper"
        >
          <swiper-slide v-for="i in 6" :key="i">
            <div class="slide-inner">
              <img
                src="~/assets/images/Banner.png"
                class="slide-inner__slide-img"
                alt="banner"
              />
            </div>
          </swiper-slide>
        </swiper>
      </ClientOnly>
    </div>
  </div>
</template>

<script lang="ts">
// Import Swiper Vue.js components
import { Swiper, SwiperSlide } from 'swiper/vue'
import { Autoplay, Pagination } from 'swiper'
// Import Swiper styles
import 'swiper/css'
import 'swiper/css/autoplay'
import 'swiper/css/pagination'

export default {
  components: {
    Swiper,
    SwiperSlide,
  },
  data() {
    return {
      activeIndex: 0,
      autoplay: {
        delay: 4000,
        disableOnInteraction: false,
      },
      modules: [Autoplay, Pagination],
    }
  },
}
</script>

<style lang="scss">
.swiper {
  width: 100%;
  height: 100%;
  margin-left: auto;
  margin-right: auto;
  padding-bottom: 1rem;
  .swiper-pagination {
    margin-bottom: -1rem;
  }
}

.slide-inner {
  height: 100%;
  position: relative;
  &__slide-img {
    // filter: brightness(95%);
    width: 100%;
    object-fit: cover;
    height: auto;
    border-radius: $--border-radius-base;
  }
  &__in-title {
    position: absolute;
    bottom: 1rem;
    right: 1rem;
    color: white;
    font-size: 1.5rem;
    margin: 0;
  }
}
</style>
