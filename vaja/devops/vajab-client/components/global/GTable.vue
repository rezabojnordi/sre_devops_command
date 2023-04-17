<template>
  <div
    class="g-table-container"
    :class="{ 'g-table-outlined': outlined, 'remove-empty': $slots.empty }"
  >
    <table
      v-if="loading || !noEmpty || items.length || notMounted"
      class="market-price-table g-table"
    >
      <thead v-show="options.header.show">
        <tr>
          <th
            v-for="(column, i) in headers"
            :key="i"
            :style="`min-width: ${column.minWidth}px; min-width: ${column.maxWidth}px;`"
            :class="column.align"
          >
            <div class="g-table__cell">
              {{ column.text }}
            </div>
          </th>
        </tr>
      </thead>
      <tbody class="g-table__body">
        <tr v-for="(item, i) in items" :key="i" class="g-table__row">
          <td
            v-for="(column, j) in headers"
            :key="j"
            :class="column.align"
            :style="`min-width: ${column.minWidth}px; max-width: ${column.maxWidth}px;`"
          >
            <div class="g-table__cell">
              <div>
                <div>
                  <slot
                    v-if="$slots && $slots[column.value]"
                    :name="column.value"
                    v-bind="item"
                  />
                  <span v-else>
                    {{ item[column.value] }}
                  </span>
                </div>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
      <div v-if="!items.length && !$slots.empty">
        <span class="g-table__empty"> اطلاعاتی وجود ندارد </span>
      </div>
    </table>
    <div v-if="!items.length && $slots.empty">
      <span>
        <slot name="empty" />
      </span>
    </div>
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface Col {
  align: string
  text: string
  value: string
  show: string
  minWidth: [string, number]
  maxWidth: [string, number]
}
interface DynamicObj {
  [key: string]: number | string | boolean
}
export default {
  props: {
    options: {
      type: Object as PropType<DynamicObj>,
      default: () => ({
        header: {
          show: true,
        },
      }),
      require: false,
    },
    items: {
      type: Object as PropType<DynamicObj[]>,
      default: () => [],
      require: false,
    },
    headers: {
      type: Array as PropType<Col[]>,
      default: () => [],
      require: false,
      note: {
        align: 'center || right || left',
        text: 'header text',
        value: 'key of value in items array',
      },
    },
    loading: {
      type: Boolean,
      default: false,
      require: false,
    },
    noEmpty: {
      type: Boolean,
      default: false,
      require: false,
      note: 'you can make true when add remove empty class (used in histories)',
    },
    outlined: {
      type: Boolean,
      default: false,
      require: false,
      note: 'outlined style',
    },
  },
  data() {
    return {
      sort: '',
      currentPage: 1,
      currentindex: 0,
      breakSize: 768,
      lgWidth: 1048,
      notMounted: true,
    }
  },
  computed: {
    // get the row data for specific page
    // rowfilters() {
    // return this.formatrow.slice(this.currentindex, this.currentindex + this.perpage)
    // },
  },
  mounted() {
    this.notMounted = false
  },
  methods: {},
}
</script>

<style lang="scss" scoped>
.g-table-container {
  display: block;
  overflow-x: auto;
  position: relative;
  min-height: 11rem;
}
.g-table {
  display: table;
  border-collapse: separate;
  border-spacing: 0 0.8rem;
  width: 100%;
  max-width: 100%;
  min-height: 7rem;
  &__cell {
    padding-right: 0.9rem;
    padding-left: 0.9rem;
  }
  &__row {
  }
  &__empty {
    padding: 3rem 0;
    text-align: center;
    position: absolute;
    right: 50%;
    transform: translate(50%, -3rem);
    color: #7d7d7d;
  }
  th {
    text-align: inherit;
    font-size: 0.9rem;
    color: $--color-neutral-300;
    font-weight: 400;
    padding: 0.92rem 0;
    background-color: $--color-white !important;
    border-top: 1px solid $--border-color-2;
    border-bottom: 1px solid $--border-color-2;
    &:first-of-type {
      border-right: 1px solid $--border-color-2;
      border-top-right-radius: 0.7rem;
      border-bottom-right-radius: 0.7rem;
    }
    &:last-of-type {
      border-left: 1px solid $--border-color-2;
      border-top-left-radius: 0.7rem;
      border-bottom-left-radius: 0.7rem;
    }
  }
  td {
    padding: 1rem 0;
    font-size: 0.9rem;
    background-color: #f6f6f6;
    &:first-of-type {
      border-top-right-radius: 0.7rem;
      border-bottom-right-radius: 0.7rem;
      padding-right: 0.5rem;
    }
    &:last-of-type {
      border-top-left-radius: 0.7rem;
      border-bottom-left-radius: 0.7rem;
      padding-left: 0.5rem;
    }
  }
  .left {
    text-align: left;
  }
  .right {
    text-align: right;
  }
  .center {
    text-align: center;
  }
  td.left {
    text-align: left;
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
  }
  td.right {
    text-align: right;
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
  }
  td.center {
    text-align: center;
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
  }
}

.g-table-outlined {
  .g-table {
    border-spacing: 0 1.2rem;
  }

  th {
    border-color: transparent !important;
  }
  td {
    padding: 0.95rem 0;
    background-color: transparent;
    border-top: 1px solid $--border-color-2;
    border-bottom: 1px solid $--border-color-2;
    &:first-of-type {
      border-right: 1px solid $--border-color-2;
      border-top-right-radius: 0.7rem;
      border-bottom-right-radius: 0.7rem;
    }
    &:last-of-type {
      border-left: 1px solid $--border-color-2;
      border-top-left-radius: 0.7rem;
      border-bottom-left-radius: 0.7rem;
    }
  }
}
</style>
