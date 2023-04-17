<template>
  <button
    type="submit"
    class="c-btn"
    :class="{
      'c-btn-primary': type === 'primary',
      'c-btn-success': type === 'success',
      'c-btn-danger': type === 'danger',
      'c-btn-info': type === 'info',
      'is-outlined': outlined,
      'is-plain': plain,
      'is-text': textButton,
    }"
    :disabled="disabled"
  >
    <span v-if="loading" style="display: inline-block">
      <GBtnSpinner />
    </span>
    <span v-else class="text-slot"> <slot /></span>
  </button>
</template>

<script>
export default {
  name: 'GlobalBtn',
  introduction: 'main website btn',
  token: '<g-btn>btn text</g-btn>',
  props: {
    loading: {
      type: Boolean,
      required: false,
      default: false,
      note: 'show loading when this prop is true',
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false,
      note: 'for desabling btn',
    },
    type: {
      type: String,
      required: false,
      default: 'primary',
    },
    outlined: {
      type: Boolean,
      required: false,
      default: false,
    },
    plain: {
      type: Boolean,
      required: false,
      default: false,
    },
    textButton: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
}
</script>

<style media="screen" lang="scss">
.c-btn {
  padding: 0.62rem 0.5rem;
  min-width: 80px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 42px;
  font-size: 0.8rem;
  font-weight: 700;
  color: $--color-white;
  border-radius: 0.5rem;
  border: 1px solid $--color-primary;
  transition: all 0.2s;
  cursor: pointer;
  &:disabled {
    opacity: 0.4;
    cursor: not-allowed;
    background-color: $--disabled-color;
    border-color: $--disabled-color;
    color: #6e6e6d;
  }
}

.c-btn-primary {
  background-color: $--color-primary;
  border-color: $--color-primary;
  &.is-plain {
    background-color: $__color-secondary-50;
    border-color: $__color-secondary-50;
    color: $--color-primary;
  }
  &.is-outlined {
    background-color: transparent;
    color: $--color-primary;
  }
  &.is-text {
    background-color: transparent;
    border: none;
    box-shadow: none;
    color: $--color-text-placeholder;
  }
}

.c-btn-info {
  background-color: $--color-neutral-300;
  border-color: $--color-neutral-300;
  &.is-plain {
    background-color: #f6f6f6;
    border-color: #f6f6f6;
    color: $--color-neutral-300;
  }
  &.is-outlined {
    background-color: transparent;
    color: $--color-neutral-300;
  }
}

.c-btn-success {
  background-color: $--color-success;
  border-color: $--color-success;
  &.is-plain {
    background-color: $--color-success-50;
    border-color: $--color-success-50;
    color: $--color-success-300;
  }
  &.is-outlined {
    background-color: transparent;
    color: $--color-primary;
  }
}

.c-btn-danger {
  background-color: $--color-danger;
  border-color: $--color-danger;
  &.is-plain {
    background-color: $--color-danger-50;
    border-color: $--color-danger-50;
    color: $--color-danger-300;
  }
  &.is-outlined {
    background-color: transparent;
    color: $--color-danger;
  }
}

.c-btn-warning {
  background-color: $--color-warning;
  border-color: $--color-warning;
  &.is-plain {
    background-color: $--color-warning-50;
    border-color: $--color-warning-50;
    color: $--color-warning-300;
  }
  &.is-outlined {
    background-color: transparent;
    color: $--color-warning;
  }
}
.text-slot > * {
  vertical-align: middle;
}
@media (max-width: 48em) {
  .c-btn {
    font-size: 0.9rem;
    min-height: 40px;
    min-width: 6rem;
  }
}
</style>
