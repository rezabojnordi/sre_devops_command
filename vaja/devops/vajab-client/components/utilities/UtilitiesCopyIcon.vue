<template>
  <span>
    <input :id="id" :value="text" type="hidden" />
    <Tooltip class="g-row g-align-center">
      <span
        :class="icon"
        class="mx-3 cursor-pointer"
        @click="copyCode()"
      ></span>
      <template #popper>
        {{ copyText }}
      </template>
    </Tooltip>
  </span>
</template>

<script>
import { Tooltip } from 'floating-vue'
import 'floating-vue/dist/style.css'
import { v4 as uuidv4 } from 'uuid'

export default {
  components: {
    Tooltip,
  },
  props: {
    text: {
      type: String,
      default: '',
      require: true,
    },
    icon: {
      type: String,
      default: 'icon-copy-success',
      require: false,
    },
  },
  data() {
    return {
      id: uuidv4(),
      copyText: 'برای کپی کردن کلیک کنید',
    }
  },
  methods: {
    copyCode() {
      const testingCodeToCopy = document.getElementById(this.id)
      if (!testingCodeToCopy) {
        return
      }
      testingCodeToCopy.setAttribute('type', 'text')
      testingCodeToCopy.select()
      testingCodeToCopy.setSelectionRange(0, 99999)
      try {
        document.execCommand('copy')
        this.copyText = 'آدرس کپی شد!'
        setTimeout(() => {
          this.copyText = 'برای کپی کردن کلیک کنید'
        }, 2000)
      } catch (e) {
        console.log(e)
      }
      /* unselect the range */
      testingCodeToCopy.setAttribute('type', 'hidden')
      window.getSelection().removeAllRanges()
    },
  },
}
</script>

<style lang="scss" scoped></style>
