<template>
  <Doughnut class="doughnut" :data="data" :options="options" />
</template>

<script setup lang="ts">
import {
  Chart as ChartJS,
  ArcElement,
  Tooltip,
  Legend,
  ChartData,
  ChartOptions,
} from 'chart.js'
import { Doughnut } from 'vue-chartjs'

interface DoughnutChartPropsInterface {
  data: ChartData
  options?: ChartOptions
}

ChartJS.register(ArcElement, Tooltip, Legend)

const props = defineProps<DoughnutChartPropsInterface>()
</script>

<style scoped>
.doughnut {
  position: relative;
  width: 100%;
}
</style>
