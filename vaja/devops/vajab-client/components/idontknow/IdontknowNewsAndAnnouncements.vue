<template>
  <idontknow-mini-box class="news-box">
    <template #header>
      <div class="news-box__header">
        <span class="text-sm-1">اخبار و اطلاعیه های وجب</span>
        <div class="news-box__header__subtitle">
          <NuxtLink>مشاهده همه</NuxtLink>
        </div>
      </div>
    </template>
    <div class="news-box__body">
      <div
        v-for="itemNew in news"
        :key="itemNew.link"
        class="news-box__body__item"
      >
        <img :src="itemNew.image" alt="" />
        <div>
          <span class="text-sm-2">{{ itemNew.title }}</span>
          <span class="news-box__body__item__time text-regular-5">{{
            $filters.jalaliMoment(itemNew.date, 'jYYYY/jMM/jDD - hh:mm')
          }}</span>
        </div>
      </div>
    </div>
  </idontknow-mini-box>
</template>

<script setup lang="ts">
export interface NewsInterface {
  image: string
  title: string
  date: Date
  link: string
}

const news = ref<Array<NewsInterface>>([
  {
    image: '',
    title: 'عنوان اطلاعیه در اینجا قرار میگیرد',
    date: new Date(),
    link: '',
  },
  {
    image: '',
    title: 'عنوان خبر های وجب یا اطلاعیه ها در اینجا قرار میگیرد',
    date: new Date(),
    link: '',
  },
  {
    image: '',
    title: 'عنوان خبر در اینجا قرار میگیرد',
    date: new Date(),
    link: '',
  },
])
</script>

<style lang="scss" scoped>
.news-box {
  &__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
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
    flex-direction: column;
    gap: 1.5rem;
    &__item {
      display: flex;
      gap: 1rem;
      img {
        background: $--color-neutral-30;
        width: 4rem;
        height: 4rem;
        border-radius: $--border-radius-base;
      }
      div {
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
      &__time {
        direction: ltr;
        text-align: right;
      }
    }
  }
}
</style>
