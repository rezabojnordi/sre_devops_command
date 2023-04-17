<template>
  <div class="radio-button-group noselect">
    <label
      v-for="item in items"
      role="radio"
      class="radio-button-group__item"
      :class="{
        'radio-button-group__item-active': item[keyName] === selected[keyName],
      }"
    >
      <input
        v-model="selected"
        type="radio"
        autocomplete="off"
        class="radio-button-group__item-orig-radio"
        :value="item"
      />
      <slot v-if="$slots.item" name="item" v-bind="item" />
      <span v-else class="radio-button-group__item-inner text-sm-2">{{
        item[label]
      }}</span>
    </label>
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'

interface Obj {
  [_: string]: any
}
export default {
  props: {
    items: {
      type: Array as PropType<Obj[]>,
      default: () => [],
    },
    modelValue: {
      type: Object as PropType<Obj>,
      require: false,
      default: {},
    },
    label: {
      type: String,
      required: true,
      default: 'text',
    },
    keyName: {
      type: String,
      require: false,
      default: 'value',
    },
  },
  emits: ['update:modelValue'],
  computed: {
    selected: {
      get(): Obj {
        return this.modelValue
      },
      set(newValue: Obj) {
        this.$emit('update:modelValue', newValue)
      },
    },
  },
}
</script>

<style lang="scss" scoped>
.radio-button-group {
  color: $--color-neutral-900;
  display: flex;
  &__item {
    position: relative;
    flex: 1;
    border: 1px solid $--border-color-2;
    border-right-width: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
    background-color: $--color-white;
    &:first-of-type {
      border-right-width: 1px;
      border-top-right-radius: $--border-radius-base;
      border-bottom-right-radius: $--border-radius-base;
      box-shadow: none;
    }
    &:last-of-type {
      border-top-left-radius: $--border-radius-base;
      border-bottom-left-radius: $--border-radius-base;
    }
  }
  &__item-active {
    color: $--color-primary;
    background-color: #edf4f5;
    box-shadow: 1px 0 0 0 $--color-primary;
    border-color: $--color-primary;
  }
  &__item-orig-radio {
    opacity: 0;
    outline: none;
    position: absolute;
    z-index: -1;
  }
  &__item-inner {
    padding: 0.7rem 1rem;
  }
}
</style>
