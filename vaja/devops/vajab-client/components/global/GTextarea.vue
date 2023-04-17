<template>
  <div class="global-textarea">
    <label v-if="label" class="global-textarea__top-label text-sm-2">{{
      label
    }}</label>
    <textarea
      ref="textarea"
      v-bind="{ ...computedProps }"
      v-model="data"
      class="textarea simple"
      :style="computedStyle"
      rows="3"
    />
    <div v-if="!noError" class="global-input__error-text">
      <transition name="fade">
        <span v-if="error">{{ $t(error) }}</span>
      </transition>
    </div>
  </div>
</template>

<script setup lang="ts">
// Define Type
import { CSSProperties } from 'vue'

const props = defineProps({
  ...useFormProps,
  label: {
    type: String,
  },
  modelValue: { type: String, default: '' },
  placeholder: { type: String },
  autosize: { type: Boolean, default: false },
  minRows: {
    type: Number,
    default: 1,
    validator: (prop: number) => prop > 0 && (prop | 0) === prop,
  },
  maxRows: {
    type: Number,
    validator: (prop: number) => prop > 0 && (prop | 0) === prop,
  },
  noError: {
    type: Boolean,
    default: false,
  },
  error: {
    type: String,
    default: '',
  },
})

const emit = defineEmits<{
  (e: 'update:modelValue', modelValue: string): void
}>()

const data = useVModel(props, 'modelValue', emit)
const xxx = ref<string>('')
const textarea = shallowRef<HTMLTextAreaElement>()

const rowHeight = ref(-1)
const height = ref(-1)

const isResizable = computed(() => {
  return Boolean(
    (props.autosize || props.maxRows || props.minRows !== 1) && textarea.value
  )
})

// const updateRowHeight = () => {
//   if (isResizable.value) {
//     rowHeight.value = calculateRowHeight()
//   }
// }
// const updateHeight = () => {
//   if (isResizable.value) {
//     height.value = calculateHeight()
//   }
// }
// onMounted(() => {
//   updateRowHeight()
//   updateHeight()
// })
// watch(
//   () => props.modelValue,
//   () => {
//     nextTick(updateHeight)
//   }
// )
const computedStyle = computed(
  () =>
    ({
      minHeight: rowHeight.value * props.minRows + 'px',
      maxHeight: props.maxRows
        ? rowHeight.value * props.maxRows + 'px'
        : undefined,
      height: height.value + 'px',
      resize: isResizable.value ? undefined : 'none',
    } as CSSProperties)
)
const computedProps = computed(() => ({
  ...reactivePick(props, 'disabled', 'readonly', 'placeholder'),
}))
const focus = () => {
  textarea.value?.focus()
}
const blur = () => {
  textarea.value?.blur()
}
</script>

<style scoped lang="scss">
.global-textarea {
  display: flex;
  flex-direction: column;
  &__top-label {
    display: block;
    text-align: right;
    margin-bottom: 1rem;
  }
}
.textarea {
  padding: 0.5rem;
  border: 0;
  font-family: var(--va-font-family);
}
.simple {
  background-color: $--color-white;
  border-radius: $--border-radius-base;
}
</style>
