<template>
  <figure class="qrcode">
    <vue-qrcode :value="value" :width="300" :margin="0" type="image/webp" />
    <span class="qrcode__center" />
  </figure>
</template>

<script setup lang="ts">
import VueQrcode from 'vue-qrcode'

const props = defineProps<{
  value: string
}>()
</script>

<style lang="scss">
.qrcode {
  display: block;
  max-width: 110px;
  margin: 0 auto;
  font-size: 0;
  margin-bottom: 0;
  position: relative;
  img {
    width: 100%;
  }
}

// .qrcode__center {
//   border: 0.4rem solid #fff;
//   border-radius: 40%;
//   height: 25%;
//   left: 50%;
//   overflow: hidden;
//   position: absolute;
//   top: 50%;
//   transform: translate(-50%, -50%);
//   width: 25%;
//   background-color: $--color-primary;
// }
</style>
