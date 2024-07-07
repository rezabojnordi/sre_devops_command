<template>
  <div :class="['g-col', classList]" :style="style">
    <slot />
  </div>
</template>

<script lang="ts">
import { capitalize } from 'vue'

export default {
  name: 'GCol',
  props: {
    xs: Number,
    sm: Number,
    md: Number,
    lg: Number,
    xl: Number,
    offsetXs: Number,
    offsetSm: Number,
    offsetMd: Number,
    offsetLg: Number,
    offsetXl: Number,
    flex1: Boolean,
  },
  data() {
    return {
      classList: [''],
      style: {
        paddingLeft: '',
        paddingRight: '',
      },
    }
  },
  computed: {
    gutter() {
      let parent = this.$parent
      while (parent && parent.$options.componentName !== 'GRow') {
        parent = parent.$parent
      }
      return parent ? parent.gutter : 0
    },
    yGutter() {
      let parent = this.$parent
      while (parent && parent.$options.componentName !== 'GRow') {
        parent = parent.$parent
      }
      return parent ? parent.yGutter : 0
    },
  },
  created() {
    if (this.gutter) {
      this.style.paddingLeft = this.gutter / 2 + 'px'
      this.style.paddingRight = this.style.paddingLeft
    }
    if (this.yGutter) {
      this.style.paddingTop = this.gutter / 2 + 'px'
      this.style.paddingBottom = this.style.paddingLeft
    }
    const breakpoints = ['xs', 'sm', 'md', 'lg', 'xl']
    breakpoints.forEach((size) => {
      let key = ('offset' + capitalize(size)) as keyof typeof this
      if (this[key]) {
        console.log(this[key], key)
        this.classList.push(`g-col-${size}-offset-${this[key]}`)
      }
      key = size as keyof typeof this
      if (this[key]) {
        this.classList.push(`g-col-${size}-${this[key]}`)
      }
      if (this.flex1) {
        this.classList.push('flex-1')
      }
    })
  },
}
</script>

<style lang="scss" scoped></style>
