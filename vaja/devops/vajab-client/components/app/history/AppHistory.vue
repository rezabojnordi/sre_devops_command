<template>
  <div class="history">
    <div v-for="item in otcHistories" :key="item.id" class="history__item">
      <div class="history__item__logo">
        <img :src="item.image.from" />
        <img :src="item.image.to" />
      </div>
      <div class="history__item__title text-title-5">
        <span>{{ item.title }}</span>
      </div>
      <div class="history__item__price text-regular-4">
        <span>{{ item.price }}</span>
      </div>
      <div class="history__item__date text-regular-4">
        <span>{{
          $filters.jalaliMoment(item.date, 'jYYYY/jMM/jDD - hh:mm:ss')
        }}</span>
      </div>
      <g-btn class="history__item__action" outlined @click="openDetail(item.id)"
        >جزییات</g-btn
      >
    </div>
    <utilities-side-popup v-model="showDetail" title="جزئیات">
      <div class="history__popup">
        <div class="history__popup__title">
          <div class="history__item__logo">
            <img :src="selectedItem.image.from" />
            <img :src="selectedItem.image.to" />
          </div>
          <div class="history__item__title">
            <span class="text-title-3">{{ selectedItem.title }}</span>
            <span>{{
              $filters.jalaliMoment(selectedItem.date, 'jYYYY/jMM/jDD - hh:mm')
            }}</span>
          </div>
        </div>
        <hr class="dashed" />
        <div class="history__popup__detail">
          <div class="history__popup__detail__item">
            <span>وضعیت:</span>
            <span class="text-title-5 color-success">تکمیل شده</span>
          </div>
          <div class="history__popup__detail__item">
            <span>محاسبه با نرخ :</span>
            <span>
              <span class="text-regular-5 mx-1 color-placeholder">(USDT)</span>
              <span>20.000</span>
            </span>
          </div>
          <div class="history__popup__detail__item">
            <span>کارمزد :</span>
            <span>
              <span class="text-regular-5 mx-1 color-placeholder">(USDT)</span>
              <span>12</span>
            </span>
          </div>
        </div>
        <hr class="dashed" />
        <div class="history__popup__more">
          <div class="history__popup__detail__item">
            <span>شناسه تبدیل :</span>
            <span>515861526156</span>
          </div>
        </div>
      </div>
    </utilities-side-popup>
  </div>
</template>

<script setup lang="ts">
// Type
export interface HistoryOtcInterface {
  id: number
  image: {
    from: string
    to: string
  }
  title: string
  price: string
  date: Date
  detail: string
}

const tblOptions = ref({
  header: {
    show: false,
  },
})
const header = ref([
  {
    text: 'عکس',
    value: 'image',
  },
  {
    text: 'عنوان',
    value: 'title',
  },
  {
    text: 'قیمت',
    value: 'price',
  },
  {
    text: 'تاریخ',
    value: 'date',
  },
  {
    text: 'جزییات',
    value: 'detail',
  },
])
const otcHistories = ref<Array<HistoryOtcInterface>>([
  {
    id: 1,
    image: {
      from: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
      to: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    },
    title: 'تبدیل ۱۰۰۰ تتر به ۱ بیتکوین',
    price: 'در قیمت ۶۰۰٫۰۰۰٫۰۰۰ تومان',
    date: new Date(),
    detail: 'جزییات',
  },
  {
    id: 2,
    image: {
      from: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
      to: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    },
    title: 'تبدیل 999 تتر به ۱ بیتکوین',
    price: 'در قیمت ۶۰۰٫۰۰۰٫۰۰۰ تومان',
    date: new Date(),
    detail: 'جزییات',
  },
  {
    id: 3,
    image: {
      from: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
      to: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    },
    title: 'تبدیل 998 تتر به ۱ بیتکوین',
    price: 'در قیمت ۶۰۰٫۰۰۰٫۰۰۰ تومان',
    date: new Date(),
    detail: 'جزییات',
  },
])

const selectedItem = ref<HistoryOtcInterface>()
const showDetail = ref<boolean>(false)
const openDetail = (historyId: number) => {
  selectedItem.value = otcHistories.value.find((el) => el.id === historyId)
  showDetail.value = true
}
</script>

<style scoped lang="scss">
.history {
  padding: 0 2rem;
  &__item {
    padding: 1rem;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 1rem;
    &:not(:last-child) {
      border-bottom: 1px solid $--color-neutral-30;
    }
    &__logo {
      display: flex;
      height: 2rem;
      width: 2rem;
      position: relative;
      align-items: center;
      justify-content: center;
      img {
        position: absolute;
        width: 1.5rem;
        height: 1.5rem;
        &:first-child {
          transform: translate(-5px, -5px);
        }
        &:last-child {
          transform: translate(5px, 5px);
        }
      }
    }
    &__price {
      flex-grow: 1;
    }
    &__title {
      display: flex;
      flex-direction: column;
    }
  }
  &__popup {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    &__title {
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    &__detail {
      display: flex;
      flex-direction: column;
      gap: 1rem;
      &__item {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
    }
  }
}
</style>
