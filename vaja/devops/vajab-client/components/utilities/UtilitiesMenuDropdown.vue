<template>
  <div
    ref="dropdown"
    class="menu-dropdown"
    @mouseover="event !== 'click' ? (show = true) : ''"
    @mouseleave="event !== 'click' ? (show = false) : ''"
    @click="event === 'click' ? (show = !show) : ''"
  >
    <span
      v-if="$slots.title"
      class="menu-dropdown__title"
      :class="{ 'menu-dropdown__active-title': show }"
    >
      <slot name="title"></slot>
    </span>
    <transition name="dropdown-transition" mode="out-in">
      <div
        v-if="show"
        class="menu-dropdown__body"
        :style="`padding-top: ${topMargin}px;`"
      >
        <div
          class="menu-dropdown__body-inner"
          :style="`min-width: ${minWidth};`"
        >
          <div @click.stop="show = false">
            <slot name="body"></slot>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script lang="ts">
export default {
  props: {
    minWidth: {
      type: [String, Number],
      require: false,
      default: '',
      // you must add unit of minWidth px, rem or %, ...
    },
    topMargin: {
      type: [Number, String],
      require: false,
      default: 0,
      // just add number and it will be pixels
    },
    event: {
      type: String,
      require: false,
      default: 'hover',
    },
  },
  data() {
    return {
      show: false,
    }
  },
}
</script>

<style lang="scss" scoped>
.menu-dropdown {
  position: relative;
  &__title {
    cursor: pointer;
    transition: all 0.2s;
  }
  &__body {
    position: absolute;
    right: 0;
    top: 100%;
    transform: scaleY(1);
    opacity: 1;
    z-index: 100;
    min-width: 100%;
  }
  &__body-inner {
    background-color: $--color-white;
    padding: 0.6rem;
    border-radius: 0 0 0.5rem 0.5rem;
    border: 1px solid #ededed;
    min-width: 100%;
    box-shadow: 0px 16px 24px rgba(26, 26, 26, 0.16);
  }
  &__arrow {
    display: inline-block;
    padding: 0 0.7rem;
    vertical-align: middle;
    color: inherit;
  }
  &__active-title {
    color: $--color-primary;
  }
}

.dropdown-transition-enter-active,
.dropdown-transition-leave-active {
  transition: all 0.12s ease;
}

.dropdown-transition-enter-from,
.dropdown-transition-leave-to {
  transform: scaleY(0);
  opacity: 0;
}
</style>
