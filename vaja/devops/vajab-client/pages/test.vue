<template>
  <div class="test">
    <g-input class="xxx" style="width: 200px" :height="200"></g-input>
    <div class="ali">
      <div class="ali__1">1</div>
      <div class="ali__2">2</div>
    </div>
  </div>
</template>

<script setup lang="ts">
const selectedTab = ref<number>(0)
</script>

<style lang="scss" scoped>
.ali {
  background-color: green;
  width: 500px;
  height: 600px;
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  &__1 {
    background-color: #2d5d6a;
    height: 2rem;
    width: 50%;
  }
  &__2 {
    background-color: #083843;
    height: 2rem;
    width: 50%;
  }
}
.test {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.xxx {
  background-color: red;
  div:first-child {
    background-color: green;
  }
}
</style>
