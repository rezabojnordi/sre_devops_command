<template>
  <div>
    <AppAccountCard
      icon="icon-user-edit"
      :path="path"
      :has-help="true"
      :tabs="tabs"
      class="profile-account-card"
      @openHelp="helpPopup = true"
    >
      <div
        v-for="item in filteredNotification"
        :key="item.id"
        class="notice__item notice__item__public"
        :class="getItemClass(item.noticeType)"
      >
        <div class="notice__item__header">
          <span class="flex-grow text-title-5">{{ item.title }}</span>
          <span class="text-title-6">{{ item.noticeType }}</span>
          <span class="text-title-6">{{
            $filters.jalaliMoment(item.date, 'jYYYY/jMM/jDD - hh:mm')
          }}</span>
        </div>
        <div class="notice__item__body text-regular-4">{{ item.content }}</div>
      </div>
      <div v-if="filteredNotification.length === 0" class="notice__item__empty">
        <img src="~/assets/images/ops.svg" alt="" />
        <span class="text-regular-5">اعلانی برای نمایش موجود نیست</span>
      </div>
    </AppAccountCard>
  </div>
</template>

<script setup lang="ts">
import { NoticeTypeEnum } from '~/constant/enum/notice.type.enum'
import { Notification } from '~/types/account/notification.interface'

const path = ref({
  parent: 'حساب کاربری',
  child: 'اعلان ها',
})
const selectedTab = ref({
  text: 'همه',
  value: 1,
})

const tabs = ref([
  {
    text: 'همه',
    value: 1,
  },
  {
    text: 'خوانده شده',
    value: 2,
  },
  {
    text: 'خوانده نشده',
    value: 3,
  },
])
const helpPopup = ref(false)

const notification = ref<Array<Notification>>([
  {
    id: 1,
    noticeType: NoticeTypeEnum.PUBLIC,
    title: 'کاربر گرامی',
    date: new Date(),
    content:
      'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط سخت تایپ به پایان رسد وزمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.',
    isRead: true,
  },
  {
    id: 2,
    noticeType: NoticeTypeEnum.PRIVATE,
    title: 'هشدار',
    date: new Date(),
    content:
      'ورود با آی پی ناشناس(192.168.1.1)\n' +
      'ما متوجه شدیم که آدرسآی پی شما با اخرین بازدید مطابقت ندارد. (زمان 1401/06/23 - 12 :23)',
    isRead: true,
  },
])

const filteredNotification = computed(() => {
  return notification.value.filter((item) => {
    if (selectedTab.value.value === 1) {
      return true
    } else if (selectedTab.value.value === 2) {
      return item.isRead
    } else if (selectedTab.value.value === 3) {
      return !item.isRead
    }
  })
})

const getItemClass = (noticeType: NoticeTypeEnum) => {
  switch (noticeType) {
    case NoticeTypeEnum.PUBLIC:
      return 'notice__item__public'
    case NoticeTypeEnum.PRIVATE:
      return 'notice__item__private'
    default:
      return ''
  }
}
</script>

<style lang="scss">
.input-edit-icon {
  color: #c8c7c6;
  margin-right: 0.2rem;
  cursor: pointer;
}

.input-success-icon {
  color: $--color-success-300;
  margin-right: 0.2rem;
}

.profile-account-card {
  .account-card {
    min-height: calc(100vh - 110px);
  }
}

.notice__item {
  border-radius: $--border-radius-base;
  padding: 2rem;
  border: 1px solid;
  margin-bottom: 2rem;
  &__public {
    background-color: $--color-neutral-20;
    color: $--color-text-placeholder;
    border-color: $--border-color-base;
  }
  &__private {
    background-color: $--color-secondary-50;
    color: $--color-primary;
    border-color: $--color-primary;
  }
  &__header {
    display: flex;
    gap: 1rem;
    margin-bottom: 1rem;
    span:first-child {
      flex-grow: 1;
    }
  }
  &__empty {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 3rem;
    gap: 1rem;
    img {
      width: 6.25rem;
    }
  }
}
</style>
