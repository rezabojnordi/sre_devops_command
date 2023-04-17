<script setup lang="ts">
const items = ref([])
const headers = ref([
  {
    text: 'زمان ورود',
    value: 'createdAt',
    minWidth: '142',
  },
  {
    text: 'دستگاه',
    value: 'userAgent',
    minWidth: '230',
  },
  {
    text: 'IP ورود',
    value: 'ip',
    minWidth: '150',
  },
  {
    text: 'مکان ورود',
    value: 'location',
    minWidth: '250',
  },
  {
    text: 'عملیات',
    value: 'operation',
    minWidth: '90',
  },
])
const loading = ref<boolean>(false)
</script>

<template>
  <g-table
    class="light-table"
    :items="items"
    :headers="headers"
    :loading="loading"
    outlined
  ></g-table>
</template>

<style scoped></style>
