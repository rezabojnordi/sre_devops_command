<template>
  <section>
    <div class="account-card">
      <div v-if="$slots.customHead || path" class="account-card-head">
        <div v-if="$slots.customHead" class="account-card-head__custom">
          <slot name="customHead" />
        </div>
        <!--        <div v-else-if="path">-->
        <!--          <span v-if="icon" class="account-card-head__icon" :class="icon" />-->
        <!--          <span class="account-card-head__parent">{{ path.parent }}</span>-->
        <!--          <span v-if="path.child" class="account-card-head__slash">/</span>-->
        <!--          <span v-if="path.child" class="account-card-head__child">{{-->
        <!--            path.child-->
        <!--          }}</span>-->
        <!--        </div>-->
      </div>
      <div
        v-if="tabs.length || hasHelp || customeMiddleSection"
        class="account-card__middle-outer"
      >
        <slot v-if="customeMiddleSection" name="middleSection" />
        <div v-else class="account-card__middle-inner">
          <div>
            <div v-if="tabs.length">
              <UtilitiesButtonGroup v-model="selectedTab" :items="tabs" />
            </div>
          </div>
          <div
            v-if="hasHelp"
            class="account-card__help"
            @click="$emit('openHelp')"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="18"
              height="18"
              viewBox="0 0 18 18"
              fill="none"
            >
              <path
                d="M9 16.5C13.125 16.5 16.5 13.125 16.5 9C16.5 4.875 13.125 1.5 9 1.5C4.875 1.5 1.5 4.875 1.5 9C1.5 13.125 4.875 16.5 9 16.5Z"
                stroke="#6D6A69"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                d="M9 6V9.75"
                stroke="#6D6A69"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                d="M8.99609 12H9.00283"
                stroke="#6D6A69"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
            راهنما
          </div>
        </div>
      </div>
      <div class="account-card__body">
        <slot />
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import type { PropType } from 'vue'
interface Path {
  parent: string
  child: string
}
interface Button {
  text: string
  value: number
}

export default {
  props: {
    path: {
      type: Object as PropType<Path>,
      default: () => {},
      require: false,
    },
    icon: {
      type: String,
      require: false,
    },
    customeMiddleSection: {
      type: Boolean,
      require: false,
      default: false,
    },
    tabs: {
      type: Array as PropType<Button[]>,
      require: false,
      default: () => [],
    },
    selected: {
      type: Object as PropType<Button>,
      require: false,
      default: () => {},
      note: 'if you add tabs it`s required',
    },
    hasHelp: {
      type: Boolean,
      require: false,
      default: false,
    },
  },
  computed: {
    selectedTab: {
      get() {
        return this.selected
      },
      set(newValue: Button) {
        this.$emit('update:selected', newValue)
      },
    },
  },
  created() {
    if (this.tabs.length && !this.selected) this.selectedTab = this.tabs[0]
  },
}
</script>

<style lang="scss" scoped>
.account-card {
  &__middle-outer {
    padding: 1rem 2rem 0;
  }
  &__middle-inner {
    border-bottom: 1px solid $--border-color-base;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 2rem 0;
  }
  &__help {
    color: $--color-neutral-300;
    font-size: 0.9rem;
    cursor: pointer;
    svg {
      margin: 0 0.3rem;
      vertical-align: middle;
      width: 1.1rem;
    }
  }
  &__body {
    padding: 2rem 2.5rem;
    @media (max-width: 48rem) {
      padding: 1rem 1.2rem;
    }
  }
}

.account-card-head {
  //border-bottom: 1px solid $--border-color-base;
  //padding: 1.56rem 1.25rem 1.25rem 1.25rem;
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
</style>
