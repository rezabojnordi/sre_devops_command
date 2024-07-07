<template>
  <transition name="fade">
    <div v-if="modelValue" class="dialog-outer" @click="handleModal">
      <div
        ref="dialog"
        class="dialog-inner"
        :style="`max-width: ${maxWidth}px`"
      >
        <slot />
      </div>
    </div>
  </transition>
</template>

<script lang="ts">
export default {
  props: {
    modelValue: {
      type: Boolean,
      require: true,
      default: false,
    },
    modal: {
      type: Boolean,
      require: false,
      default: false,
    },
    maxWidth: {
      type: [String, Number],
      require: false,
      default: '',
      note: 'max-width by pixel unit',
    },
  },
  emits: ['update:modelValue'],
  data() {
    return {}
  },
  methods: {
    handleModal(event) {
      if (this.$refs.dialog && !this.modal) {
        if (!this.$refs.dialog.contains(event.target)) {
          this.$emit('update:modelValue', false)
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.dialog-outer {
  position: fixed;
  z-index: 1000;
  width: 100%;
  height: 100%;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background: rgba(0, 0, 0, 0.24);
  padding: 1rem;
}
.dialog-inner {
  position: relative;
  top: 50%;
  right: 50%;
  transform: translate(50%, -50%);
  background-color: white;
  width: 100%;
  max-width: 37.625rem;
  min-height: 18rem;
  border-radius: 1.25rem;
  padding: 1rem 1rem 1.6rem 1rem;
  transition: all 0.3s;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
