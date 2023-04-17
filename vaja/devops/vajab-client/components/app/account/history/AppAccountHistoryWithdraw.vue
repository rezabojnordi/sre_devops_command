<template>
  <g-table :items="items" :headers="headers">
    <template #currency="item">
      <div class="table-currency">
        <img src="~/assets/images/account/BTC.svg" :alt="item.currency" />
        <span v-if="item.currency == 'IRT'">تومان</span>
        <span v-else>{{ item.title }} ({{ item.currency }})</span>
      </div>
    </template>

    <template #amount="item">
      <b v-if="item.currency == 'IRT'">{{
        $filters.toCurrency(item.amount)
      }}</b>
      <b v-else>{{ item.amount }}</b>
    </template>

    <template #createdAt="item">
      <div class="text-regular-5">
        {{ $filters.jalaliMoment(item.createdAt, 'hh:mm jYYYY-jMM-jDD') }}
      </div>
    </template>

    <template #status="item">
      <span v-if="item.status == 0" class="color-warning">در انتظار تایید</span>
      <span v-if="item.status == 1" class="color-warning">در انتظار</span>
      <span v-if="item.status == 2" class="color-success">موفق</span>
      <span v-if="item.status == 3" class="color-danger">رد شده</span>
    </template>

    <template #txId="item">
      <div class="table-text numeric-table-row">
        <a
          v-if="item.explorer && item.txId"
          :href="item.explorer + item.txId"
          class="c-link"
          target="_blank"
          >{{ item.txId }}</a
        >
        <span v-else>{{ item.txId ? item.txId : '--' }}</span>
      </div>
    </template>
    <template #operation="item">
      <div class="g-row">
        <g-btn
          class="w-100 mr-auto"
          style="background-color: white; max-width: 96px"
          outlined
          @click=";(selectedItem = item), (detailDialog = true)"
        >
          جزئیات
        </g-btn>
      </div>
    </template>
  </g-table>

  <UtilitiesSidePopup
    v-model="detailDialog"
    title="جزئیات برداشت"
    :no-close-in-out="false"
  >
    <div v-if="selectedItem" class="history-detail">
      <div class="history-detail__head">
        <div class="history-detail__head-title">
          <img
            src="~/assets/images/account/BTC.svg"
            :alt="selectedItem.currency"
          />
          <div class="history-detail__context">
            <div class="text-title-3">
              {{ selectedItem.currency }}
            </div>
            <div class="text-light text-regular-5">
              {{
                $filters.jalaliMoment(
                  selectedItem.createdAt,
                  'hh:mm jYYYY-jMM-jDD'
                )
              }}
            </div>
          </div>
        </div>
        <div class="history-detail__value">
          -{{ selectedItem.amount }} {{ selectedItem.currency }}
        </div>
      </div>

      <div class="history-detail__item">
        <span>وضعیت</span>
        <b v-if="selectedItem.status == 0" class="color-warning"
          >در انتظار تایید</b
        >
        <b v-if="selectedItem.status == 1" class="color-warning">در انتظار</b>
        <b v-if="selectedItem.status == 2" class="color-success">موفق</b>
        <b v-if="selectedItem.status == 3" class="color-danger">رد شده</b>
      </div>
      <div class="history-detail__item">
        <span>دارایی :</span>
        <span
          ><span class="text-light text-regular-5 mx-1"
            >({{ selectedItem.title }})</span
          >
          {{ selectedItem.currency }}</span
        >
      </div>
      <div class="history-detail__item">
        <span>مقدار برداشتی :</span>
        <span v-if="selectedItem.currency === 'IRT'">{{
          $filters.toCurrency(selectedItem.amount)
        }}</span>
        <span v-else>{{ selectedItem.amount }}</span>
      </div>
      <div class="history-detail__item">
        <span>شبکه :</span>
        <span>{{ selectedItem.network }}</span>
      </div>
      <div class="history-detail__item">
        <span>TXID</span>
        <span>{{ selectedItem.txId }}</span>
      </div>
      <g-btn plain type="info" class="w-100 mt-5" @click="detailDialog = false">
        بستن
      </g-btn>
    </div>
  </UtilitiesSidePopup>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface DepositItem {
  currency: string
  createdAt: string
  amount: string
  status: number | string
  title: string
  network: string
  txId: string
}
export default {
  props: {
    items: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      selectedItem: Object as PropType<DepositItem>,
      detailDialog: false,
      headers: [
        {
          text: 'ارز',
          value: 'currency',
          minWidth: 120,
        },
        {
          text: 'تاریخ',
          value: 'createdAt',
          minWidth: 120,
        },
        {
          text: 'وضعیت',
          value: 'status',
          minWidth: 115,
        },
        {
          text: 'مقدار',
          value: 'amount',
          minWidth: 90,
        },
        {
          text: 'کدپیگیری',
          value: 'txId',
          minWidth: 160,
        },
        {
          text: '',
          value: 'operation',
          maxWidth: 88,
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.table-currency {
  font-weight: 700;
  img {
    vertical-align: middle;
    margin-left: 10px;
  }
}
.history-detail {
  &__head {
    padding-bottom: 1.7rem;
    padding-top: 0.2rem;
    border-bottom: 1px dashed $--border-color-base;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  &__head-title {
    display: flex;
    img {
      margin-left: 0.625rem;
      margin-top: 0.3rem;
      height: 2rem;
    }
    &__context {
      flex: 1;
    }
  }
  &__value {
    background: #ededed;
    border-radius: $--border-radius-base;
    padding: 0.625rem 0.75rem;
    font-size: 0.8rem;
    direction: ltr;
  }
  &__item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 0.9rem;
    margin: 1.2rem 0;
  }
}
</style>
