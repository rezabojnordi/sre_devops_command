<template>
  <transition name="right-shift" mode="out-in">
    <div
      v-show="modelValue"
      v-if="vshowMode || modelValue"
      class="popup-outer"
      @click.stop="shacking()"
    >
      <div class="side-popup" @click.stop>
        <div class="side-popup__head">
          <div class="side-popup__title">
            {{ title }}
          </div>
          <div class="cursor-pointer" @click="close()">
            <span class="side-popup__back-text"> بازگشت </span>
            <span class="side-popup__icon">
              <span class="icon-arrow-left" :class="{ shaking: shaking }" />
            </span>
          </div>
        </div>

        <div class="side-popup__body">
          <slot />
        </div>
      </div>
    </div>
  </transition>
</template>

<script lang="ts">
export default {
  props: {
    modelValue: {
      type: Boolean,
      require: false,
      default: false,
    },
    title: {
      type: String,
      default: '',
      require: false,
    },
    vshowMode: {
      type: Boolean,
      require: false,
      default: false,
      note: 'using v-show exept of v-if',
    },
    noCloseInOut: {
      type: Boolean,
      require: false,
      default: true,
    },
  },
  emits: ['update:modelValue'],
  data() {
    return {
      shaking: false,
    }
  },
  methods: {
    close() {
      this.$emit('update:modelValue', false)
    },
    shacking() {
      if (this.noCloseInOut) {
        this.shaking = true
        setTimeout(() => {
          this.shaking = false
        }, 1000)
      } else {
        this.close()
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.popup-outer {
  background: rgba(0, 0, 0, 0.24);
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1000;
}

.side-popup {
  height: 100%;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  max-width: 32rem;
  background-color: $--color-white;
  opacity: 1;
  transition: all 0.3s ease-in-out;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  &__head {
    border-bottom: 1px solid $--border-color-base;
    padding: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  &__title {
    color: $--color-neutral-900;
    font-weight: 600;
    font-size: 1.1rem;
  }
  &__back-text {
    color: $--color-neutral-900;
    font-size: 1rem;
    margin: 0 0.6rem;
  }
  &__icon {
    background-color: $__color-secondary-50;
    width: 2.75rem;
    height: 2.75rem;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: $--color-primary;
    border-radius: 100%;
    span {
      transition: color 0.2s;
    }
  }
  &__body {
    padding: 1.5rem;
    flex: 1;
  }
}

.right-shift-enter-active,
.right-shift-leave-active {
  transition: all 0.3s ease;
}

.right-shift-enter-from,
.right-shift-leave-to {
  opacity: 0;
  .side-popup {
    right: -100%;
  }
}

.shaking {
  animation: bellshake 1s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
  backface-visibility: hidden;
  transform-origin: top right;
  color: $--color-danger-300;
  font-weight: 900;
}

@keyframes bellshake {
  0% {
    transform: rotate(0);
  }
  15% {
    transform: rotate(10deg);
  }
  30% {
    transform: rotate(-10deg);
  }
  45% {
    transform: rotate(8deg);
  }
  60% {
    transform: rotate(-8deg);
  }
  75% {
    transform: rotate(4deg);
  }
  85% {
    transform: rotate(-4deg);
  }
  92% {
    transform: rotate(1deg);
  }
  100% {
    transform: rotate(0);
  }
}
</style>
