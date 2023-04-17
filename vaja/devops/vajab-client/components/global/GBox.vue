<template>
  <div
    class="box"
    :class="[shadow && `shadow-${shadow}`, rounded && `rounded-${rounded}`]"
  >
    <slot></slot>
    <div v-if="loading" class="box__loading">
      <div>Loading...</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  RoundedTypeEnum,
  ShadowTypeEnum,
} from '~/constant/enum/component/global/box.enum'

const props = withDefaults(
  defineProps<{
    loading?: boolean
    shadow?: ShadowTypeEnum
    rounded?: RoundedTypeEnum
  }>(),
  {
    loading: false,
  }
)
</script>

<style lang="scss">
.box {
  background-color: $--color-white;
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
  &__loading {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgb(68, 167, 192, 0.1);
    backdrop-filter: blur(6px);
    opacity: 1;
    z-index: 2;
    display: flex;
    justify-content: center;
    align-items: center;
  }
}
.shadow {
  &-1 {
    box-shadow: $--box-shadow-1;
  }
  &-2 {
    box-shadow: $--box-shadow-3;
  }
  &-3 {
    box-shadow: $--box-shadow-4;
  }
}
.rounded {
  &-sm {
    border-radius: $--border-radius-small;
  }
  &-base {
    border-radius: $--border-radius-base;
  }
  &-lg {
    border-radius: $--border-radius-lg;
  }
  &-circle {
    border-radius: 50%;
  }
}
</style>
