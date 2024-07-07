<template>
  <idontknow-mini-box class="estimate-box">
    <template #header>
      <div class="estimate-box__header">
        <span class="text-sm-1">ارزش تخمینی دارایی ها</span>
        <div class="estimate-box__header__subtitle">
          <div>
            <span class="color-primary text-title-4">۳۳۴٫۲۱۹</span>
            <span>تومان</span>
          </div>
          <div>
            <span class="color-primary text-title-4">۱۴٫۱۳۴</span>
            <span>تتر</span>
          </div>
        </div>
      </div>
    </template>
    <div class="estimate-box__body">
      <div class="estimate-box__body__detail">
        <div>
          <span class="icon-wallet"></span>
          <span class="text-sm-2">بیشترین ارز های شما :</span>
        </div>
        <ul>
          <li v-for="wallet in walletSummary" :key="wallet.symbol">
            <span
              class="list-style"
              :style="`color: ${wallet.color}`"
              v-html="'&#8728;'"
            ></span>
            <span class="text-title-4">{{ wallet.name }}</span>
            <span class="flex-1 text-regular-5 mr-1"
              >( {{ wallet.symbol }} )</span
            >
            <span class="text-title-6 ml-1">{{
              easyReadNumber(wallet.value, 0).show
            }}</span>
            <span class="text-regular-6">تومان</span>
          </li>
        </ul>
      </div>
      <div class="estimate-box__body__chart">
        <UtilitiesDoughnutChart
          :data="chartData"
          :options="chartOptions"
        ></UtilitiesDoughnutChart>
      </div>
    </div>
    <template #footer>
      <div class="estimate-box__footer">
        <NuxtLink class="text-sm-3">مشاهده جزئیات کیف پول شما</NuxtLink>
      </div>
    </template>
  </idontknow-mini-box>
</template>

<script setup lang="ts">
import { ChartData, ChartOptions } from 'chart.js'

const walletSummary = ref([
  {
    symbol: 'BTC',
    name: 'بیت کوین',
    color: stringToColorHSL('BTC'),
    value: 1000000,
  },
  {
    symbol: 'USDT',
    name: 'تتر',
    color: stringToColorHSL('USDT'),
    value: 1000000,
  },
  {
    symbol: 'ETH',
    name: 'اتریوم',
    color: stringToColorHSL('ETH'),
    value: 1000000,
  },
])

const chartData = ref<ChartData>({
  labels: walletSummary.value.map((el) => el.name),
  datasets: [
    {
      backgroundColor: walletSummary.value.map((el) => el.color),
      data: walletSummary.value.map((el) => el.value),
    },
  ],
})

const chartOptions = ref<ChartOptions>({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    tooltip: {
      enabled: false,
    },
    legend: {
      display: false,
    },
  },
})

const list = ref(null)
</script>

<style lang="scss" scoped>
.estimate-box {
  &__header {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    @media (min-width: 48em) {
      justify-content: space-between;
    }
    &__subtitle {
      display: flex;
      & > div {
        margin: 0 0.5rem;
        span {
          margin: 0 0.25rem;
        }
      }
    }
  }

  &__body {
    display: flex;
    width: 100%;
    gap: 1rem;
    &__detail {
      flex: 2;
      //width: 58%;
      align-self: center;
      .icon-wallet {
        color: $--color-neutral-50;
        vertical-align: middle;
        margin-left: 0.5rem;
      }
      ul {
        padding: 0;
        list-style: none;
        margin: 1.5rem 0;
      }
      li {
        display: flex;
        margin-bottom: 1rem;
        .list-style {
          font-weight: bold;
          display: flex;
          width: 1rem;
        }
        span {
          align-self: center;
        }
      }
    }
    &__chart {
      flex: 1;

      //width: 38%;
    }
  }

  &__footer {
    display: flex;
    justify-content: center;
    a {
      color: #555150;
    }
  }
}
</style>
