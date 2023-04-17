<template>
  <div class="checkbox">
    <input v-model="data" type="checkbox" />
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
interface CheckboxPropsInterface {
  modelValue: boolean
}

const props = defineProps<CheckboxPropsInterface>()
const emits = defineEmits<{
  (e: 'update:modelValue', modelValue: boolean): void
}>()
const data = useVModel(props, 'modelValue', emits)
// const value = computed({
//   get() {
//     return this.modelValue
//   },
//   set(newVal) {
//     console.log(newVal)
//   },
// })
</script>

<style lang="scss" scoped>
.checkbox {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
input[type='checkbox'] {
  position: relative;
  display: block;
  margin: 0 auto;
  cursor: pointer;
  height: 1.5rem;
  width: 2.5rem;

  &:before {
    content: '';
    display: block;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    height: 1.5rem;
    width: 2.5rem;
    background-color: #bbb;
    border-radius: 14px;
    transition: background-color 0.2s;
    cursor: pointer;
  }

  &:after {
    content: '';
    display: block;
    position: absolute;
    transition: transform 0.2s, -webkit-transform 0.2s;
    top: 50%;
    left: 50%;
    transform: translate(-10%, -50%);
    border-radius: 12px;
    box-shadow: 0 2px 3px rgba(0, 0, 0, 0.3);
    background-color: #fff;
    height: 1.25rem;
    width: 1.25rem;
    cursor: pointer;
  }

  &:checked {
    &:before {
      background-color: $--color-primary;
    }
    &:after {
      transform: translate(-90%, -50%);
      -webkit-transform: translate(-90%, -50%);
    }
  }
}
</style>
