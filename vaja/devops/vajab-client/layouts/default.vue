<template>
  <div>
    <div>
      <MainHeader />
    </div>
    <main class="main-layout">
      <transition name="fade" mode="out-in">
        <div v-if="showBackground" class="main-layout-background"></div>
      </transition>
      <transition name="fade">
        <slot />
      </transition>
    </main>
    <div v-if="$route.path.split('/')[1] !== 'account'">
      <MainFooter />
    </div>
  </div>
</template>

<script lang="ts">
export default {
  setup() {
    const { showBackground } = useBackground()
    return {
      showBackground,
    }
  },
}
</script>

<style lang="scss">
.main-layout {
  // overflow-x: hidden;
  position: relative;
  z-index: 2;
  &-background {
    content: '';
    background: url('~/assets/images/faq/faq.back.pattern.png')
      $__color-primary-50;
    mix-blend-mode: color-burn;
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    height: 154px;
  }
}
</style>
