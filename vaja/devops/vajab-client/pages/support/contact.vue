<template>
  <div class="main-container contact">
    <g-row justify="space-between">
      <g-col class="contact" :xs="10">
        <h3>تماس با ما</h3>
        <p class="text-regular-4">
          مشتری گرامی، در واحد پشتیبانی همواره آماده پاسخگویی به سوالات و رفع
          نیازهای شما هستیم. پیشنهاد می شود از طریق ارسال تیکت در حساب کاربری
          خود با ما در ارتباط باشید. کارشناسان ما در اسرع وقت پاسخگوی شما خواهند
          بود. همچنین می توانید از طریق شماره تلفن پشتیبانی با ما تماس گرفته و
          یا از طریق چت آنلاین در سایت، سوالات خود را مطرح نمایید.
        </p>
        <span class="text-title-5 color-primary my-3"
          >به علت نوع کسب و کار از پاسخگویی بصورت حضوری معذوریم</span
        >
        <ul class="contact__list">
          <li
            v-for="way in contactWays"
            :key="way.text"
            class="contact__list__item"
          >
            <img :src="useAssetMedia(way.img)" alt="" />
            <span class="text-title-5">{{ way.text }}</span>
          </li>
        </ul>
      </g-col>
      <g-col class="contact__form" :xs="12">
        <g-row :gutter="10">
          <g-col :xs="12">
            <g-input filled top-label label="نام و نام خانوادگی"></g-input>
          </g-col>
          <g-col :xs="12">
            <g-input filled top-label label="ایمیل"></g-input>
          </g-col>
        </g-row>
        <g-input filled top-label height="200" label="موضوع پیام"></g-input>
        <g-btn>ارسال پیام</g-btn>
      </g-col>
    </g-row>
  </div>
</template>

<script setup lang="ts">
// Types
interface ContactWayInterface {
  text: string
  img: string
}

// Logic
const contactWays = ref<Array<ContactWayInterface>>([
  {
    text: 'پشتیبانی تلگرام : Vajabsupport',
    img: '/assets/images/support/contact/support_contact_telegram.svg',
  },
  {
    text: 'تلفن های پشتیبانی : ۲۳۴۵۶۷۸۹-۰۵۱ ( ۹ الی ۱۷ )',
    img: '/assets/images/support/contact/support_contact_call.svg',
  },
  {
    text: 'پشتیبانی ایمیل : support@vajab.ir',
    img: '/assets/images/support/contact/support_contact_mail.svg',
  },
  {
    text: 'آدرس : خراسان رضوی، مشهد، میدان جانباز، برج اداری پاژ',
    img: '/assets/images/support/contact/support_contact_location.svg',
  },
])
</script>

<style lang="scss" scoped>
.contact {
  margin-top: 4rem;
  h3 {
    margin-top: 0;
  }
  & > p {
    color: $--color-text-placeholder;
  }
  &__form {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    justify-content: space-between;
    & > div {
      width: 100%;
    }
    div:nth-child(3) {
      flex-grow: 1;
      width: 100%;
    }
    button {
      width: 100%;
    }
  }
  &__list {
    padding: 0;
    &__item {
      list-style: none;
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
      gap: 1rem;
      img {
        background-color: #edf4f5;
        padding: 0.7rem;
        border-radius: $--border-radius-base;
        width: 2.5rem;
        height: 2.5rem;
      }
      span {
        color: $--color-neutral-300;
      }
    }
  }
}
</style>
