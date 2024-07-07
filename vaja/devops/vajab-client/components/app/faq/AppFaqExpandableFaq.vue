<template>
  <g-col>
    <g-row alignment="center">
      <button
        class="rounded-button ml-2"
        :class="isOpen && 'expanded'"
        @click="toggle"
      >
        <span v-if="isOpen">-</span>
        <span v-else>+</span>
      </button>
      <h3 :class="isOpen ? 'text-title-4' : 'text-regular-3'">
        {{ question }}
      </h3>
    </g-row>
    <g-row
      :class="isOpen ? 'answer__expanded' : 'answer__close'"
      class="answer text-regular-4"
    >
      <p>{{ answer }}</p>
    </g-row>
  </g-col>
</template>

<script setup lang="ts">
import { ExpandableFaqPropsInterface } from '~/types/support/faq.interface'

const isOpen = ref<boolean>(false)
const toggle = () => {
  isOpen.value = !isOpen.value
}

const { question, answer } = defineProps<ExpandableFaqPropsInterface>()
</script>

<style lang="scss" scoped>
.rounded-button {
  border-radius: 100%;
  border: none;
  background-color: $__color-secondary-50;
  width: 2rem;
  height: 2rem;
  font-size: 1.5rem;
  line-height: 1.5rem;
  color: $__color-primary-300;
  aspect-ratio: 1;
  font-weight: 400;
  cursor: pointer;
  transition: all 0.7s ease;
}
.expanded {
  background-color: $__color-primary-300;
  color: $__color-white;
}
.answer {
  background-color: $__color-neutral-20;
  border-radius: $__border-radius-small;
  overflow: hidden;
  transition: all 0.7s ease-in-out;
  p {
    padding: 2rem 3rem;
  }

  &__expanded {
    max-height: 1000px;
  }

  &__close {
    max-height: 0px;
  }
}
</style>
