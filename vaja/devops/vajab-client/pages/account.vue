<template>
  <div class="account-page">
    <div class="account-page__side-menu">
      <app-account-side-menu :items="items" />
    </div>
    <div class="account-page__page">
      <div class="account-page__bread-crumb">
        <span
          v-if="path && path.icon"
          class="account-page__bread-crumb__icon"
          :class="path.icon"
        ></span>
        <span class="account-page__bread-crumb__parent">{{ path.parent }}</span>
        <span v-if="path.child" class="account-page__bread-crumb__slash"
          >/</span
        >
        <span v-if="path.child" class="account-page__bread-crumb__child">{{
          path.child
        }}</span>
        <!--        TODO: create auto generate breadcrumb-->
      </div>
      <div class="account-page__page__inner">
        <NuxtPage />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  pageTransition: {
    name: 'slide-right',
    mode: 'out-in',
  },
  middleware(to, from) {
    to.meta.pageTransition.name =
      +to.params.id > +from.params.id ? 'slide-left' : 'slide-right'
  },
})

const items = ref([
  {
    icon: 'icon-menu',
    text: 'داشبورد',
    to: '/account/dashboard',
  },
  {
    icon: 'icon-menu',
    text: 'حساب کاربری',
    children: [
      {
        text: 'مشخصات کاربر',
        to: '/account/profile',
      },
      {
        text: 'امنیت',
        to: '/account/security',
      },
      {
        text: 'حساب های بانکی',
        to: '/account/bankcards',
      },
      {
        text: 'اعلان ها',
        to: '/account/notifications',
      },
      {
        text: 'درخواست ها',
        to: '/account/support-requests',
      },
    ],
  },
  {
    icon: 'icon-wallet',
    text: 'کیف پول',
    children: [
      {
        text: 'دارایی ها',
        to: '/account/assets',
      },
      {
        text: 'واریز',
        to: '/account/assets/deposit',
      },
      {
        text: 'برداشت',
        to: '/account/assets/withdraw',
      },
    ],
  },
  {
    icon: 'icon-money-change',
    text: 'پرداخت',
    children: [
      {
        text: 'پرداخت سریع',
        to: '/account/pay',
      },
      {
        text: 'شناسه دریافت آنی',
        to: '/account/pay/deposit',
      },
    ],
  },
  {
    icon: 'icon-calendar-half',
    text: 'تاریخچه',
    children: [
      {
        text: 'واریز',
        to: '/account/history/deposit',
      },
      {
        text: 'برداشت',
        to: '/account/history/withdraw',
      },
      {
        text: 'معاملات',
        to: '/account/history/otc',
      },
    ],
  },
])

// path component logic

// Type
interface PathOptionsInterface {
  icon?: string
  parent?: string
  child?: string
}
// const path = ref<PathOptionsInterface>({
//   icon: '',
//   parent: 'سلام',
//   child: 'خوبی',
// })
const route = useRoute()

const path = computed<PathOptionsInterface>(() => {
  return findPath(route.fullPath)
})

const findPath = (path: string): PathOptionsInterface => {
  let child = '',
    parent = '',
    icon = ''
  for (let i = 0; i < items.value.length; i++) {
    const item = items.value[i]
    if (item.to === path) {
      parent = item.text
      icon = item.icon
    } else if (item.children) {
      for (let j = 0; j < item.children.length; j++) {
        const childEl = item.children[j]
        if (childEl.to === path) {
          icon = item.icon
          parent = item.text
          child = childEl.text
        }
      }
    }
  }
  return {
    child,
    parent,
    icon,
  }
}
</script>

<style lang="scss" scoped>
.account-page {
  display: flex;
  background-color: #f6f6f6;
  min-height: calc(100vh - 90px);
  &__page {
    width: 100%;
    &__inner {
      background: red;
      margin: 0 1.25rem;
      background-color: $--color-white;
      border-radius: $--border-radius-lg;
    }
  }
  &__bread-crumb {
    //border-bottom: 1px solid $--border-color-base;
    padding: 1.56rem 1.25rem 1.25rem 1.25rem;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    &__icon {
      width: 2.75rem;
      height: 2.75rem;
      background-color: $__color-secondary-50;
      color: $--color-primary;
      border-radius: 100%;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    &__parent {
      color: #c8c7c6;
      margin-right: 1.25rem;
    }
    &__slash {
      color: #c8c7c6;
      margin: 0 1.25rem;
    }
    &__child {
      color: $--color-neutral-900;
    }
    &__custom {
      flex: 1;
    }
  }
}
</style>
