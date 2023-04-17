<template>
  <div class="mini-box">
    <div v-if="$slots.header">
      <slot name="header"></slot>
      <hr />
    </div>
    <div class="mini-box__main">
      <slot></slot>
    </div>
    <div v-if="$slots.footer">
      <hr />
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<script setup lang="ts"></script>

<style lang="scss" scoped>
.mini-box {
  background-color: $--color-white;
  border-radius: $--border-radius-base;
  box-shadow: $--box-shadow-1;
  padding: 2rem;
  height: 100%;
  display: flex;
  flex-direction: column;
  &__main {
    flex-grow: 1;
    display: flex;
    align-items: center;
  }
  hr {
    border: 1px solid $--border-color-2;
  }
}
</style>
