<template>
  <g-col class="faq-content">
    <app-faq-expandable-faq
      v-for="qa in content"
      :answer="qa.answer"
      :question="qa.question"
    ></app-faq-expandable-faq>
  </g-col>
</template>

<script setup lang="ts">
import { FaqContentPropsInterface } from '~/types/support/faq.interface'

const { content } = defineProps<FaqContentPropsInterface>()
</script>

<style lang="scss" scoped></style>
