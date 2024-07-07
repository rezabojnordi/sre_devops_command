<template>
  <div
    class="global-input"
    :class="{
      'global-input-showMode': showMode,
      'global-input-error': error.length,
      'global-input-disabled': disabled,
      'global-input-filled': filled,
    }"
  >
    <div class="global-input__inner">
      <div class="prepended">
        <span v-if="icon" class="global-input__icon" :class="icon"></span>
        <slot v-if="$slots.prepended" name="prepended" />
        <label v-if="label" class="global-input__label" @click="focus()">{{
          label
        }}</label>
      </div>
      <input
        :id="inputId"
        v-model="v"
        :placeholder="placeholder"
        :showMode="showMode"
        :readonly="readonly"
        :disabled="disabled"
        :autofocus="autofocus"
        :autocomplete="autocomplete"
        :type="type === 'password' && showPassword ? 'text' : type"
        :maxlength="maxlength"
        class="global-input__input"
        :class="{
          'global-input__password-input': type === 'password' && !showPassword,
        }"
        @input="$emit('input', v)"
      />
      <div v-if="type === 'password'" class="appended">
        <span
          class="global-input__password-icon icon-eye"
          @click="showPassword = !showPassword"
        ></span>
      </div>
      <div v-if="$slots.appended" class="appended">
        <slot name="appended" />
      </div>
    </div>
    <div v-if="!error.length && description" class="global-input__des">
      {{ description }}
    </div>
    <div v-if="!noError" class="global-input__error-text">
      <transition name="fade">
        <span v-if="error.length">{{ error }}</span>
      </transition>
    </div>
    <slot name="button" />
  </div>
</template>

<script>
import { v4 as uuidv4 } from 'uuid'

export default {
  props: {
    label: {
      type: String,
      required: false,
      default: '',
    },
    icon: {
      type: String,
      required: false,
      default: '',
    },
    value: {
      type: [String, Number],
      required: false,
      default: '',
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false,
    },
    inputId: {
      type: String,
      required: false,
      default: `input-${uuidv4()}`,
    },
    type: {
      type: String,
      required: false,
      default: 'text',
      note: 'can be text, number, tel, ...',
    },
    maxlength: {
      type: [String, Number],
      required: false,
      default: '',
      note: 'maxlength of dtring and tel input type',
    },
    placeholder: {
      type: String,
      required: false,
      default: '',
    },
    showMode: {
      type: Boolean,
      required: false,
      default: false,
      note: 'show mode for just showing in own show styles (sample in prodile)',
    },
    description: {
      type: String,
      required: false,
      default: '',
      note: 'under input description (used in KYC)',
    },
    autofocus: {
      type: Boolean,
      required: false,
      default: false,
      note: 'auto focus input',
    },
    autocomplete: {
      type: String,
      required: false,
      default: '',
      note: 'autocompelete input',
    },
    readonly: {
      type: Boolean,
      required: false,
      default: false,
    },
    error: {
      type: String,
      required: false,
      default: '',
      note: 'if you has error text input color change to error and your error show under input',
    },
    noError: {
      type: Boolean,
      required: false,
      default: false,
    },
    showPassword: {
      type: Boolean,
      required: false,
      default: false,
    },
    filled: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  data() {
    return {
      v: this.value,
    }
  },
  watch: {
    value() {
      this.v = this.value
    },
  },
  methods: {
    focus() {
      this.$focus(this.inputId)
    },
  },
}
</script>

<style lang="scss" scoped>
.global-input {
  position: relative;
  align-items: center;
  &__label {
    display: inline-block;
    font-size: 0.9rem;
    line-height: 25px;
    color: #6d6a69;
    margin: 0 0.8rem;
    cursor: pointer;
  }
  &__icon {
    color: #c8c7c6;
    font-size: 18px;
  }
  &__error-text {
    font-size: 0.625rem;
    color: $--color-danger;
    min-height: 1.4rem;
    padding-top: 0.25rem;
  }
  &__inner {
    border: solid 1px $--border-color-base;
    border-radius: 0.5rem;
    display: flex;
    overflow: hidden;
    background-color: $--color-white;
    transition: all 0.2s;
    padding: 0 0.8rem;
  }
  &__input {
    flex: 1;
    z-index: 2;
    border: 0;
    outline: none;
    max-width: 100%;
    padding: 0.5rem 0.5rem 0.5rem 0.5rem;
    line-height: 2rem;
    background-color: transparent;
    direction: ltr;
    border: 0;
    &::placeholder {
      color: $--color-text-placeholder;
    }
    &:disabled {
      cursor: not-allowed;
    }
  }
  &__des {
    color: #7d7d7d;
    font-size: 0.8rem;
    min-height: 1.4rem;
    padding-top: 0.25rem;
  }
  &__password-icon {
    color: #888584;
    cursor: pointer;
  }
  &__password-input {
    font-size: 1.5rem;
  }
}

.global-input-filled {
  .global-input__inner {
    border: solid 1px #f6f6f6;
    background-color: #f6f6f6;
  }
}

.global-input-disabled {
  opacity: 0.4;
  .global-input__inner {
    background-color: $--disabled-color;
  }
  input {
    color: #7d7d7d !important;
  }
}

.global-input-error {
  .global-input__inner {
    border-color: $--color-danger;
  }
  .global-input__label {
    color: $--color-danger;
  }
  .global-input__icon {
    color: $--color-danger;
  }
}

.global-input:focus,
.global-input:hover {
}

.prepended {
  align-items: center;
  display: flex;
}

.appended {
  align-items: center;
  display: flex;
  img {
    width: 1rem;
  }
}

@media (max-width: 48em) {
  .global-input {
    &__label {
      display: inline-block;
      font-size: 0.9rem;
      line-height: 1.5rem;
      margin: 0 0.5rem;
    }
    input {
      font-size: 0.9rem;
      line-height: 1.5rem;
    }
  }
}

[dir='ltr'] {
  .prepended {
    padding-left: 0.8rem;
    padding-right: inherit;
  }
}
</style>
