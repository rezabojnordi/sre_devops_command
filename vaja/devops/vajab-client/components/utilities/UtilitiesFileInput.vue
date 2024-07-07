<template>
  <div class="file-input">
    <input
      ref="fileInput"
      type="file"
      name="filename"
      :accept="accept"
      class="file-input__file-input"
      @change="onFileChange"
      @click="(e: any) => e.target.value = ''"
    />
    <g-input
      filled
      type="text"
      :model-value="fileName"
      readonly
      :placeholder="placeholder"
      class="file-input__input"
      :error="error"
    >
      <template #appended>
        <span v-if="!file" class="icon-document-upload"></span>
        <span
          v-else
          class="icon-trash file-input__delete-icon"
          @click="deleteFile()"
        ></span>
      </template>
    </g-input>
  </div>
</template>

<script lang="ts">
export default {
  props: {
    accept: {
      type: String,
      default: '*',
      require: false,
    },
    modelValue: {
      type: Object,
      require: false,
      default: null,
    },
    error: {
      type: String,
      default: '',
      require: false,
    },
    placeholder: {
      type: String,
      default: '',
      require: false,
    },
  },
  emits: ['update:modelValue'],
  data() {
    return {
      fileName: '',
    }
  },
  computed: {
    file: {
      get(): object | null {
        return this.modelValue
      },
      set(newVal: object) {
        this.fileName = newVal ? newVal.name : ''
        this.$emit('update:modelValue', newVal)
      },
    },
  },
  methods: {
    onFileChange(e: any) {
      this.file = e.target.files[0]
    },
    deleteFile() {
      this.file = null
      this.$refs.fileInput.value = null
    },
  },
}
</script>

<style lang="scss" scoped>
.file-input {
  position: relative;
  &__file-input {
    opacity: 0;
    display: block;
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    bottom: 0;
    z-index: 3;
    cursor: pointer;
  }
  span {
    color: $--color-neutral-300;
  }
  &__delete-icon {
    color: $--color-danger-300 !important;
    z-index: 4;
    cursor: pointer;
  }
}
</style>
