<template>
  <g-dialog v-model="value">
    <div class="dialog-popup success-dialog">
      <img
        v-if="type === 'failed'"
        src="@/assets/images/failed-dialog.svg"
        alt="failed icon"
      />
      <img v-else src="@/assets/images/success-dialog.svg" alt="success icon" />
      <div
        class="dialog-popup__text"
        :class="
          type === 'failed'
            ? 'dialog-popup__faild-text'
            : 'dialog-popup__success-text'
        "
      >
        {{ text }}
      </div>
      <div v-if="actionText" class="dialog-popup__action">
        <g-btn :outlined="true" @click="$emit('clicked')">
          {{ actionText }}
        </g-btn>
      </div>
    </div>
  </g-dialog>
</template>

<script>
export default {
  props: {
    modelValue: {
      type: Boolean,
      require: true,
      default: false,
    },
    type: {
      type: String,
      require: false,
      default: 'success',
    },
    text: {
      type: String,
      require: false,
      default: 'عملیات موفقیت آمیز بود',
    },
    actionText: {
      type: String,
      require: false,
      default: '',
    },
  },
  emits: ['update:modelValue'],
  computed: {
    value: {
      get() {
        return this.modelValue
      },
      set(newValue) {
        this.$emit('update:modelValue', newValue)
      },
    },
  },
}
</script>

<style lang="scss" scoped>
.dialog-popup {
  text-align: center;
  padding: 5.12rem 0;
  img {
    width: 100%;
    max-width: 13.32rem;
  }
  &__text {
    color: $--color-primary;
    font-size: 1rem;
    margin-top: 1.2rem;
    margin-bottom: 2.8rem;
    font-weight: 700;
  }
  &__success-text {
    color: $--color-primary;
  }
  &__faild-text {
    color: $--color-danger;
  }
  &__action {
    max-width: 130px;
    margin: 0 auto;
  }
}
</style>
