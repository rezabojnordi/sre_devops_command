<template>
  <div class="wizard-steps-outer">
    <div class="wizard-steps">
      <div class="wizard-steps__step wizard-steps__step-active">1</div>
      <div
        class="wizard-steps__step"
        :class="{ 'wizard-steps__step-active': step === 2 }"
      >
        2
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    step: {
      type: Number,
      default: 1,
      require: true,
    },
  },
}
</script>

<style lang="scss" scoped>
.wizard-steps-outer {
  height: 100%;
  padding: 1.8rem 0 2.1rem 0;
}
.wizard-steps {
  position: relative;
  height: 100%;
  box-sizing: content-box;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  &__step {
    border: 4px solid $--border-color-2;
    border-radius: 100%;
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #c8c7c6;
    z-index: 1;
    color: $--color-white;
    font-size: 0.8rem;
  }
  &__step-active {
    border: 4px solid $--color-primary-50;
    background-color: $--color-primary;
  }
  &::before {
    content: ' ';
    position: absolute;
    right: 50%;
    top: 0;
    bottom: 0;
    transform: translateX(50%);
    border-right: 1px #c8c7c6 dashed;
  }
}
</style>
