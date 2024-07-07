<template>
  <div class="faq main-container">
    <div class="faq__background"></div>
    <g-row class="faq__content">
      <g-col :xs="6">
        <g-row class="mt-4 mb-5" alignment="center" justify="center">
          <span class="text-title-3">سوالات متداول</span>
        </g-row>
        <g-row alignment="center" justify="center">
          <app-faq-sidebar
            v-model="selectedCategoryId"
            :show-bull="searchInput !== ''"
            :categories="finds"
          ></app-faq-sidebar>
        </g-row>
      </g-col>
      <g-col :xs="18">
        <g-row class="search-box">
          <g-input
            v-model="searchInput"
            class="w-100"
            no-error
            top-label
            placeholder="جستجو در سوالات ..."
          >
            <template #appended>
              <span class="icon-search-normal"></span>
            </template>
          </g-input>
        </g-row>
        <app-faq-content
          :key="finds[selectedCategoryId].content"
          class="p-5"
          :content="finds[selectedCategoryId].content"
        ></app-faq-content>
      </g-col>
    </g-row>
  </div>
</template>

<script setup lang="ts">
import { CategoryFaqInterface } from '~/types/support/faq.interface'

const { toggle } = useBackground()

onMounted(() => {
  toggle()
})

onUnmounted(() => {
  toggle()
})

const categories = ref<Array<CategoryFaqInterface>>([
  {
    icon: 'icon-arrow-left',
    text: 'شرایط و قوانین استفاده از وجب',
    content: [
      {
        question: 'q1',
        answer: 'a1',
      },
      {
        question: 'q2',
        answer: 'a2',
      },
      {
        question: 'q3',
        answer: 'a3',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'ثبت نام و احراز هویت',
    content: [
      {
        question: 'دعوت از دوستان',
        answer: 'a1',
      },
      {
        question: 'نحوه افزودن و ویرایش اطلاعات بانکی به چه صورت است؟',
        answer: 'a2',
      },
      {
        question: 'نحوه افزودن و ویرایش اطلاعات بانکی به چه صورت است؟',
        answer: 'a2',
      },
      {
        question: 'علت تفاوت قیمت‌های شما با سایر سایت‌ها چیست؟',
        answer: 'a2',
      },
      {
        question: 'اگر رمز عبور خود را فراموش کردم، چطور آن را بازیابی کنیم؟',
        answer: 'a2',
      },
      {
        question: 'چرا ایمیلی از طرف وجب دریافت نمی‌کنم؟',
        answer: 'a2',
      },
      {
        question: 'چرا احراز هویت لازم است؟',
        answer: 'a2',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'کارمزدها و معاملات',
    content: [
      {
        question: 'q3',
        answer: 'a3',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'امنیت',
    content: [
      {
        question: 'q3',
        answer: 'a3',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'کیف پول',
    content: [
      {
        question: 'q1',
        answer: 'a1',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'پشتیبانی و اطلاع رسانی',
    content: [
      {
        question: 'q1',
        answer: 'a1',
      },
      {
        question: 'q3',
        answer: 'a3',
      },
    ],
  },
  {
    icon: 'icon-arrow-left',
    text: 'پرداخت',
    content: [
      {
        question: 'q1',
        answer: 'a1',
      },
    ],
  },
])

const selectedCategoryId = ref<number>(0)
const searchInput = ref<string>('')
const finds = computed<Array<CategoryFaqInterface>>(() => {
  if (!searchInput.value) return categories.value
  const searchInp = searchInput.value.toLowerCase()
  return categories.value.filter((el: any) => {
    const xx = el.content.filter((el2: any) => {
      return el2.question.includes(searchInp) || el2.answer.includes(searchInp)
    })
    return xx.length > 0
  })
  // const xxx = categories.value.map((el: any) => {
  //   return {
  //     ...el,
  //     content: el.content.filter((el2: any) => {
  //       return (
  //         el2.question.includes(searchInp) || el2.answer.includes(searchInp)
  //       )
  //     }),
  //   }
  // })

  console.log('xxx', xxx)
  return xxx
})
</script>

<style lang="scss" scoped>
.faq {
  position: relative;
  &__content {
    position: relative;
    z-index: 1;
  }
  .search-box {
    width: 50%;
    margin: 2rem auto 3rem;
  }
}
</style>
