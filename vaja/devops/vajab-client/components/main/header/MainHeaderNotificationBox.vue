<template>
  <div class="notification">
    <div class="notification__box">
      <div class="notification__box__inner">
        <div
          v-for="item in notifications"
          :key="item.date"
          class="notification__box__inner__item"
        >
          <div class="notification__box__inner__item__text">
            <span class="text-sm-3 new_notice">{{ item.title }}</span>
            <g-row align="center" justify="space-between">
              <span class="text-regular-5 mr-3">
                {{ $filters.jalaliMoment(item.date, 'hh:mm jYYYY-jMM-jDD') }}
              </span>
              <a class="text-sm-2" :href="item.link">نمایش جزییات</a>
            </g-row>
          </div>
        </div>
      </div>
      <div class="notification__box__footer text-regular-5">
        <span>خوانده شدن همه</span>
        <span class="notification__box__footer__inner">
          <span>مشاهده همه</span>
          <span class="icon-arrow-left mr-1"></span>
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface NotificationBoxMessage {
  title: string
  date: Date
  link?: string
}
const notifications = ref<Array<NotificationBoxMessage>>([
  {
    title: 'ورود موفق به حساب کاربری',
    date: new Date(),
  },
  {
    title: 'دو شبکه فانتوم و پالی گان به صرافی وجب اضافه شدند.',
    date: new Date(),
    link: 'https://www.google.com',
  },
  {
    title: 'قدم به قدم تا ساخت بات معامله گر',
    date: new Date(),
    link: 'https://www.google.com',
  },
  {
    title: 'قدم به قدم تا ساخت بات معامله گر',
    date: new Date(),
    link: 'https://www.google.com',
  },
  {
    title: 'قدم به قدم تا ساخت بات معامله گر',
    date: new Date(),
    link: 'https://www.google.com',
  },
  {
    title: 'قدم به قدم تا ساخت بات معامله گر',
    date: new Date(),
    link: 'https://www.google.com',
  },
  {
    title: 'قدم به قدم تا ساخت بات معامله گر',
    date: new Date(),
    link: 'https://www.google.com',
  },
])
</script>

<style lang="scss" scoped>
.notification {
  position: absolute;
  top: 100%;
  width: 24rem;
  padding: 2rem 0;
  &__box {
    background-color: $--color-white;
    border-radius: $--border-radius-base;
    box-shadow: $--box-shadow-4;
    border-bottom: 1px solid $--color-neutral-30;
    &__inner {
      max-height: 16rem;
      overflow-y: scroll;
      border-bottom: 1px solid $--color-neutral-30;
      padding: 1rem;
      &__item {
        display: flex;
        padding: 1rem 0;
        &:not(:last-child) {
          border-bottom: 1px solid $--color-neutral-30;
        }
        &__text {
          display: flex;
          width: 100%;
          flex-direction: column;
        }
      }
    }
    &__footer {
      padding: 1rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      &__inner {
        display: flex;
        align-items: center;
      }
    }
    .new_notice {
      display: flex;
      align-items: center;
      &:before {
        content: '';
        width: 0.5rem;
        height: 0.5rem;
        margin-left: 0.5rem;
        border-radius: 50%;
        background-color: $--color-danger-300;
      }
    }
  }
}
</style>
