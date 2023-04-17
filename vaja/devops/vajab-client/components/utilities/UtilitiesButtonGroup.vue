<template>
  <div class="group-btns">
    <span v-for="item in items" class="group-btns__btn-outer">
      <g-btn
        :type="item.value === selected[keyName] ? 'primary' : 'info'"
        :outlined="item[keyName] === selected[keyName]"
        :plain="item[keyName] !== selected[keyName]"
        class="group-btns__btn"
        @click="select(item)"
      >
        <slot v-if="$slots.item" name="item" v-bind="item" />
        <span v-else>
          {{ item[label] }}
        </span>
      </g-btn>
    </span>
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
      require: true,
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
      get(): Button {
        return this.modelValue
      },
      set(newValue: Button) {
        this.$emit('update:modelValue', newValue)
      },
    },
  },
  methods: {
    select(item: Button) {
      this.selected = item
    },
  },
}
</script>

<style lang="scss" scoped>
.group-btns {
  display: flex;
  flex-wrap: wrap;
  white-space: pre-line;
  overflow-x: auto;
  margin: 0 -5px;
  &__btn-outer {
    flex: 1;
    padding: 5px;
  }
  &__btn {
    min-width: 140px;
    white-space: nowrap;
  }
}
</style>
