<template>
  <div class="attention-notes">
    <div class="attention-notes__title">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="27"
        height="24"
        viewBox="0 0 27 24"
        fill="none"
      >
        <path
          d="M11.506 1.15162L0.3088 20.5443C0.10654 20.8945 3.74341e-05 21.2918 9.86635e-09 21.6962C-3.74144e-05 22.1006 0.106392 22.4979 0.308587 22.8481C0.510783 23.1984 0.801619 23.4892 1.15186 23.6914C1.5021 23.8936 1.89939 24 2.30381 24H24.6963C25.1008 24 25.4981 23.8936 25.8483 23.6914C26.1985 23.4892 26.4894 23.1984 26.6916 22.8481C26.8938 22.4979 27.0002 22.1006 27.0001 21.6962C27.0001 21.2918 26.8936 20.8945 26.6913 20.5443L15.4954 1.15162C15.2932 0.801479 15.0025 0.510724 14.6523 0.308573C14.3022 0.106423 13.905 0 13.5007 0C13.0964 0 12.6992 0.106423 12.349 0.308573C11.9989 0.510724 11.7081 0.801479 11.506 1.15162V1.15162Z"
          fill="#FFB400"
        />
        <path
          d="M13.6459 7.13281H13.3538C12.6347 7.13281 12.0518 7.71576 12.0518 8.43487V14.6585C12.0518 15.3776 12.6347 15.9606 13.3538 15.9606H13.6459C14.365 15.9606 14.948 15.3776 14.948 14.6585V8.43487C14.948 7.71576 14.365 7.13281 13.6459 7.13281Z"
          fill="#FCF4D9"
        />
        <path
          d="M13.4999 20.8962C14.2996 20.8962 14.948 20.2479 14.948 19.4481C14.948 18.6483 14.2996 18 13.4999 18C12.7001 18 12.0518 18.6483 12.0518 19.4481C12.0518 20.2479 12.7001 20.8962 13.4999 20.8962Z"
          fill="#FCF4D9"
        />
      </svg>
      <span>
        {{ title }}
      </span>
    </div>
    <div v-if="$slots.body" class="attention-notes__list-container">
      <slot name="body" />
    </div>
    <ul v-else class="attention-notes__list-container">
      <li
        v-for="(item, i) in items"
        :key="i"
        class="attention-notes__list-item"
      >
        {{ item.text }}
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface Attention {
  text: string
}
export default {
  props: {
    items: {
      type: Array as PropType<Attention[]>,
      defualt: () => [],
      require: false,
    },
    title: {
      type: String,
      defualt: '',
      require: true,
    },
  },
}
</script>

<style lang="scss" scoped>
.attention-notes {
  border: 1px solid $--border-color-2;
  border-radius: 0.625rem;
  background-color: $--color-white;
  padding: 2rem 2.5rem;
  &__title {
    display: flex;
    align-items: center;
    color: $--color-neutral-900;
    font-weight: 600;
    border-bottom: 1px solid $--border-color-2;
    padding-bottom: 2rem;
    span {
      margin: 0 0.7rem;
    }
  }
  &__list-container {
    padding: 1.3rem 0 0 0;
    margin: 0;
    list-style: none;
  }
  &__list-item {
    color: $--pure-black;
    font-size: 0.9rem;
    line-height: 2.2rem;
    list-style: none;
    padding-right: 1rem;
    position: relative;
    &::before {
      position: absolute;
      right: 0;
      top: 0.95rem;
      content: ' ';
      height: 100%;
      display: inline-block;
      border-radius: 100%;
      width: 5px;
      height: 5px;
      background-color: #c8c7c6;
    }
  }
}
</style>
