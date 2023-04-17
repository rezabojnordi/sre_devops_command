<template>
  <div class="g-row" :style="style" :class="classList">
    <slot />
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'

const RowJustify = [
  'start',
  'center',
  'end',
  'space-around',
  'space-between',
  'space-evenly',
] as const
const RowAlign = ['start', 'center', 'end'] as const
export default {
  name: 'GRow',
  componentName: 'GRow',
  props: {
    gutter: Number,
    yGutter: Number,
    justify: {
      type: String as PropType<(typeof RowJustify)[number]>,
      values: RowJustify,
      default: '',
    },
    alignment: {
      type: String as PropType<(typeof RowAlign)[number]>,
      values: RowAlign,
      default: '',
    },
  },
  data() {
    return {
      classList: [''],
    }
  },
  computed: {
    style() {
      const ret = {
        marginLeft: '',
        marginRight: '',
      }

      if (this.gutter) {
        ret.marginRight = `-${this.gutter / 2}px`
        ret.marginLeft = ret.marginRight
        return ret
      }
      return ''
    },
  },
  created() {
    if (this.justify) {
      this.classList.push(`g-justify-${this.justify}`)
    }
    if (this.alignment) {
      this.classList.push(`g-align-${this.alignment}`)
    }
  },
}
</script>
