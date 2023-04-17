<template>
  <span class="count-down">
    <span v-if="duration > 0" class="count-down__timer">
      <slot v-if="custom" :time="clockView" />
      <span v-else>
        {{ clockView }}
        {{ text }}
      </span>
    </span>
    <span v-else class="count-down__btn" @click="resend"> ارسال مجدد </span>
  </span>
</template>

<script>
export default {
  name: 'CountDown',
  props: {
    duration: {
      type: Number,
      default: 60 /* By Seconds */,
    },
    text: {
      type: String,
      default: 'ثانیه تا ارسال مجدد کد',
      require: false,
    },
    custom: {
      type: Boolean,
      default: false,
      require: false,
    },
  },
  emits: ['update:duration'],
  computed: {
    clockView() {
      return this.duration
    },
  },
  mounted() {
    this.countDown()
  },
  methods: {
    countDown() {
      if (this.duration > 0) {
        setTimeout(() => {
          this.$emit('update:duration', this.duration - 1)
          this.countDown()
        }, 1000)
      }
    },
  },
}
</script>

<style scoped lang="scss">
.count-down {
  .count-down__timer {
    // color: #A1A1A1;
    color: $--color-neutral-900;
    font-size: 0.8rem;
  }
  .count-down__btn {
    cursor: pointer;
    display: inline-block;
    color: $--color-primary;
    font-size: 1rem;
  }
}

@media (max-width: 48em) {
  .count-down {
    font-size: 0.8rem;
    .count-down__btn {
      font-size: 0.8rem;
    }
  }
}
</style>
