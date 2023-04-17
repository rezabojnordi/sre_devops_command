<template>
  <div class="dashboard">
    <div class="dashboard__item">
      <idontknow-estimate-value-assets></idontknow-estimate-value-assets>
    </div>
    <div class="dashboard__item">
      <idontknow-news-and-announcements></idontknow-news-and-announcements>
    </div>
    <div class="dashboard__item">
      <idontknow-mini-box>
        <idontknow-otc-box></idontknow-otc-box>
      </idontknow-mini-box>
    </div>
    <g-box
      :shadow="ShadowTypeEnum.BASE"
      :rounded="RoundedTypeEnum.BASE"
      class="dashboard__item__history"
    >
      <g-tab v-model="selectedTab" :tabs="tabs">
        <app-history></app-history>
      </g-tab>
    </g-box>
  </div>
</template>

<script setup lang="ts">
import {
  RoundedTypeEnum,
  ShadowTypeEnum,
} from '~/constant/enum/component/global/box.enum'

// button tab
const tabs = ref([
  { title: 'تاریخچه سفارشات' },
  // { text: 'تاریخچه معاملات', value: 1 },
])
const selectedTab = ref<number>(0)
</script>

<style scoped lang="scss">
.dashboard {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
  gap: 1rem;
  @media (min-width: 48rem) {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
  &__item {
    width: 100%;
    grid-column: span 3 / span 3;
    @media (min-width: 48rem) {
      grid-column: span 1 / span 1;
    }

    &__history {
      grid-column: span 3 / span 3;
    }
  }
}
</style>
