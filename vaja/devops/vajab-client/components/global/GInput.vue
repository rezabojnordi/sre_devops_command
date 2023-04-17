<template>
  <div
    class="global-input"
    :class="{
      'global-input-showMode': showMode,
      'global-input-error': error,
      'global-input-disabled': disabled,
      'global-input-filled': filled,
      'global-input-top-label': topLabel,
    }"
  >
    <label v-if="label && topLabel" class="global-input__top-label text-sm-2">{{
      label
    }}</label>
    <div class="global-input__inner">
      <div class="prepended">
        <span v-if="icon" class="global-input__icon" :class="icon"></span>
        <slot v-if="$slots.prepended" name="prepended" />
        <label
          v-if="label && !topLabel"
          class="global-input__label noselect"
          @click="focus()"
          >{{ label }}</label
        >
      </div>
      <input
        :id="inputId"
        ref="input"
        v-model="v"
        :name="name"
        :placeholder="placeholder"
        :showMode="showMode"
        :readonly="readonly"
        :disabled="disabled"
        :autofocus="autofocus"
        :autocomplete="autocomplete"
        :type="type === 'password' && showPassword ? 'text' : type"
        :maxlength="maxlength"
        class="global-input__input"
        :class="[
          type === 'password' &&
            !showPassword &&
            'global-input__password-input',
          `text-${textAlign}`,
        ]"
        :style="computedStyle"
        size="1"
      />
      <div v-if="type === 'password'" class="appended">
        <span
          v-if="!showPassword"
          class="global-input__password-icon icon-eye"
          @click="showPassword = true"
        ></span>
        <span
          v-else
          class="global-input__password-icon icon-eye-slash"
          @click="showPassword = false"
        ></span>
      </div>
      <div v-if="$slots.appended" class="appended">
        <slot name="appended" />
      </div>
    </div>
    <div v-if="!error && description" class="global-input__des">
      {{ description }}
    </div>
    <div v-if="!noError" class="global-input__error-text">
      <transition name="fade">
        <span v-if="error">{{ $t(error) }}</span>
      </transition>
    </div>
    <slot name="button" />
  </div>
</template>

<script setup lang="ts">
import { v4 as uuidv4 } from 'uuid'
import {
  BankcardStrategy,
  InputStrategy,
  NumberStrategy,
  TextStrategy,
} from '~/composables/useInput'

// Type Declaration
type UsageType = 'bankcard' | 'number' | 'text'
type HTMLInputTypeAttribute =
  | 'button'
  | 'checkbox'
  | 'color'
  | 'date'
  | 'datetime-local'
  | 'email'
  | 'file'
  | 'hidden'
  | 'image'
  | 'month'
  | 'number'
  | 'password'
  | 'radio'
  | 'range'
  | 'reset'
  | 'search'
  | 'submit'
  | 'tel'
  | 'text'
  | 'time'
  | 'url'
  | 'week'

interface InputProps {
  height?: number
  textAlign?: string
  usageType?: UsageType
  label?: string
  icon?: string
  modelValue?: string | number
  disabled?: boolean
  inputId?: string
  type?: HTMLInputTypeAttribute
  name?: string
  maxlength?: string | number
  placeholder?: string
  showMode?: boolean
  description?: string
  autofocus?: boolean
  autocomplete?: string
  readonly?: boolean
  error?: string
  noError?: boolean
  topLabel?: boolean
  filled?: boolean
}

const input = shallowRef<HTMLTextAreaElement>()

const props = withDefaults(defineProps<InputProps>(), {
  textAlign: '',
  modelValue: '',
  inputId: `input-${uuidv4()}`,
  type: 'text',
  name: '',
  usageType: 'text',
  filled: false,
  disabled: false,
})
const emits = defineEmits<{
  (e: 'update:modelValue', modelValue: number | string): void
}>()

/**
 * define strategy for input depend
 * usageInput
 * */
let strategy: InputStrategy
switch (props.usageType) {
  case 'bankcard':
    strategy = new InputStrategy(new BankcardStrategy())
    break
  case 'number':
    strategy = new InputStrategy(new NumberStrategy())
    break
  default:
    strategy = new InputStrategy(new TextStrategy())
    break
}

// const v = useVModel(props, 'modelValue', emits)
const showPassword = ref<boolean>(false)
const computedStyle = computed(() => {
  return {
    height: props.height && props.height + 'px',
  }
})
const v = computed({
  get() {
    return strategy.get(props.modelValue)
  },
  set(val) {
    val = strategy.set(val)
    emits('update:modelValue', val)
  },
})

const focus = () => {
  input.value?.focus()
}
const blur = () => {
  input.value?.blur()
}
</script>

<style lang="scss" scoped>
.text {
  &-right {
    text-align: right;
  }
  &-left {
    text-align: left;
  }
  &-center {
    text-align: center;
  }
}
.global-input {
  position: relative;
  align-items: center;
  &__label {
    display: inline-block;
    font-size: 0.9rem;
    line-height: 25px;
    color: #6d6a69;
    margin-right: 0.8rem;
    white-space: nowrap;
    cursor: pointer;
  }
  &__top-label {
    display: block;
    text-align: right;
    margin-bottom: 1rem;
  }
  &__icon {
    color: #c8c7c6;
    font-size: 18px;
  }
  &__error-text {
    font-size: 0.625rem;
    color: $--color-danger-300;
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
    padding: 0.1rem 0.8rem;
  }
  &__input {
    flex: 1;
    z-index: 2;
    border: 0;
    outline: none;
    max-width: 100%;
    padding: 0.2rem 0.5rem;
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
  .global-input__input {
    //direction: rtl;
    &::placeholder {
      color: #afaead;
    }
  }
}

.global-input-top-label {
  .global-input__input {
    direction: rtl;
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
    border-color: $--color-danger-300;
  }
  .global-input__label {
    color: $--color-danger-300;
  }
  .global-input__icon {
    color: $--color-danger-300;
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
  }
}

[dir='ltr'] {
  .prepended {
    padding-left: 0.8rem;
    padding-right: inherit;
  }
}
</style>
