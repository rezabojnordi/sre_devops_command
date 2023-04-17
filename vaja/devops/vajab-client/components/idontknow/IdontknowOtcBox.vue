<template>
  <div class="otc-box">
    <app-otc-inputs></app-otc-inputs>
    <div class="otc-box__submit">
      <slot v-if="$slots.action" name="action"></slot>
      <g-btn v-else class="otc-box__submit__btn" outlined>معامله سریع</g-btn>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style lang="scss" scoped>
.otc-box {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;

  &__submit {
    display: flex;
    align-items: flex-end;
    width: 100%;
    flex-grow: 1;
    &__btn {
      width: 100%;
      margin-top: 2rem;
    }
  }
}
</style>
