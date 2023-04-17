<template>
  <div class="wizard-steps-outer">
    <div class="wizard-steps">
      <div
        v-for="step in steps"
        class="wizard-steps__step"
        :style="`background-color: ${step.bgColor}`"
      >
        <span
          class="wizard-steps__step-icon"
          :style="`color: ${step.color}`"
          :class="step.icon"
        ></span>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface Steps {
  icon: string
  color: string
  bgColor: string
}
export default {
  props: {
    steps: {
      type: Array as PropType<Steps[]>,
      default: 1,
      require: true,
    },
  },
}
</script>

<style lang="scss" scoped>
.wizard-steps-outer {
  height: 100%;
  padding: 0 0 1.5rem 0;
  margin-top: -0.1rem;
}
.wizard-steps {
  position: relative;
  height: 100%;
  box-sizing: content-box;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  &__step {
    border-radius: 1.2rem;
    width: 50px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #c8c7c6;
    z-index: 1;
    color: $--color-white;
    font-size: 1.1rem;
  }
  &::before {
    content: ' ';
    position: absolute;
    right: 50%;
    top: 0;
    bottom: 0;
    transform: translateX(50%);
    border-right: 1px $--color-primary dashed;
    z-index: 0;
  }
}
</style>
