<template>
  <div class="pay-checkbox">
    <span v-if="preIcon" :class="preIcon" class="text-title-3 pay-checkbox__icon"></span>
    <div class="pay-checkbox__wrapper">
      <span class="text-sm-2">{{ title }}</span>
      <span class="text-regular-5 flex-grow-1 pay-checkbox__subTitle">{{
        subTitle
      }}</span>
    </div>
    <g-checkbox v-model="test"></g-checkbox>
  </div>
</template>

<script setup lang="ts">
interface PayCheckboxPropsInterface {
  preIcon: string
  title: string
  subTitle: string
}

const props = defineProps<PayCheckboxPropsInterface>()
const test = ref<boolean>(false)
</script>

<style lang="scss" scoped>
.pay-checkbox {
  background-color: $--color-white;
  display: flex;
  gap: 0.5rem;
  align-items: center;
  padding: 0.8rem;
  border-radius: $--border-radius-base;
  &__icon {
    color: $--color-neutral-100;
  }
  &__subTitle {
    color: $--color-neutral-300;
  }
  &__wrapper {
    display: flex;
    flex-grow: 1;
    flex-wrap: wrap;
    gap: 0.5rem;
    align-items: center;
  }
}
</style>
