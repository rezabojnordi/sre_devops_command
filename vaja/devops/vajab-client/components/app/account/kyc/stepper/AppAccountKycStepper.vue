<template>
  <div class="stepper">
    <div
      v-for="step in steps"
      class="stepper__item"
      :class="{
        stepper__pending: step.status === 1,
        stepper__compelete: step.status === 2,
        stepper__error: step.status === 3,
      }"
    >
      <span>
        {{ step.text }}
      </span>
      <div class="stepper__next-icon">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="49"
          height="72"
          viewBox="0 0 49 72"
          fill="none"
        >
          <path d="M10 0H49L39 36L49 72H10L0 36L10 0Z" fill="white" />
        </svg>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface Step {
  text: string
  status: number
}
export default {
  props: {
    steps: {
      type: Array as PropType<Step[]>,
      default: () => {},
      require: true,
    },
  },
}
</script>

<style lang="scss" scoped>
.stepper {
  display: flex;
  font-size: 1rem;
  font-weight: 700;
  &__item {
    flex: 1;
    position: relative;
    background-color: #f6f6f6;
    border-radius: 0.65rem;
    line-height: 1.5rem;
    color: $--color-neutral-300;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1.25rem 1rem;
    &:last-of-type {
      .stepper__next-icon {
        display: none;
      }
    }
  }
  &__pending {
    background-color: #edf4f5;
    color: $--color-primary;
  }
  &__compelete {
    background-color: #e8f2e0;
    color: $--color-success;
  }
  &__next-icon {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    transform: translateX(-50%);
    z-index: 1;
    svg {
      height: 100%;
      width: auto;
    }
  }
}
</style>
