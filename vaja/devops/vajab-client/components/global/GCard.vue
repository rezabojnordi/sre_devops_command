<template>
  <div class="g-card">
    <slot></slot>
  </div>
</template>

<script setup lang="ts"></script>

<style lang="scss" scoped>
.g-card {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  background-color: #f6f6f6;
  padding: 2rem 3rem;
  border-radius: $--border-radius-base;
  @media (max-width: 48rem) {
    padding: 1rem 1.5rem;
  }
}
</style>
