<template>
  <g-col class="faq-sidebar p-3">
    <g-row
      v-for="(category, idx) in categories"
      :key="idx"
      alignment="center"
      class="px-2 py-3 mb-1 category"
      :class="modelValue === idx && 'isActive'"
      @click="selectCategory(idx)"
    >
      <div class="flex-1 text-title-5">
        <span
          :class="[
            category.icon,
            modelValue === idx ? 'color-white' : 'color-primary',
          ]"
          class="ml-2"
        ></span>
        <span v-text="category.text"></span>
      </div>
      <span v-show="props.showBull" class="counter">{{
        categoryLen(category.content)
      }}</span>
    </g-row>
  </g-col>
</template>

<script setup lang="ts">
import { CategoryFaqInterface } from '~/types/support/faq.interface'

interface FaqSidebarPropsInterface {
  categories: CategoryFaqInterface[]
  modelValue: number
  showBull: boolean
}

const props = withDefaults(defineProps<FaqSidebarPropsInterface>(), {
  showBull: false,
})
const categoryLen = (category: any) => {
  return category.length
}
const emit = defineEmits<{
  (e: 'update:modelValue', modelValue: number): void
}>()

const selectCategory = (categoryId: number) => {
  emit('update:modelValue', categoryId)
}
</script>

<style lang="scss" scoped>
.faq-sidebar {
  width: 100%;
  background: $__color-white;
  border: 1px solid $--border-color-2;
  border-radius: $--border-radius-base;
  box-shadow: $--box-shadow-3;
  cursor: pointer;
  -webkit-user-select: none; /* Safari */
  -ms-user-select: none; /* IE 10 and IE 11 */
  user-select: none; /* Standard syntax */
}

.isActive {
  background-color: $--color-primary;
  color: white;
}

.category {
  border-radius: $--border-radius-small;
}
.counter {
  border-radius: 100%;
  background: $__color-primary;
  color: $__color-white;
  width: 1.25rem;
  height: 1.25rem;
  line-height: 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  display: flex;
  text-align: center;
  align-items: center;
  justify-content: center;
}
</style>
