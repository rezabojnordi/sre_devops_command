<template>
  <div class="tab">
    <ul class="tab__header">
      <li
        v-for="(tab, idx) in tabs"
        :key="idx"
        :class="modelValue === idx && 'active-item'"
        @click="selectTab(idx)"
      >
        {{ tab.title }}
      </li>
    </ul>
    <div>
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
interface TabInterface {
  title: string
}
interface TabPropsInterface {
  modelValue: number
  tabs: TabInterface
}

const props = withDefaults(defineProps<TabPropsInterface>(), {
  modelValue: 0,
})
const emit = defineEmits<{
  (e: 'update:modelValue', modelValue: number): void
}>()

const selectTab = (slcTabIdx: number) => {
  emit('update:modelValue', slcTabIdx)
}
</script>

<style scoped lang="scss">
.tab {
  padding: 1rem;
  &__header {
    display: flex;
    list-style: none;
    position: relative;
    padding: 0;
    border-bottom: 1px solid $--color-neutral-30;
    &__selected {
      border-bottom: 2px solid green;
      position: absolute;
      bottom: 0;
    }
    li {
      text-align: center;
      vertical-align: middle;
      flex: 1 1 0%;
      white-space: nowrap;
      cursor: pointer;
      max-width: fit-content;
      padding: 0.5rem 1rem;
      &.active-item {
        border-bottom: 2px solid $--color-primary;
      }
    }
  }
}
</style>
