<template>
  <transition name="right-shift" mode="out-in">
    <div
      v-if="drawer || !$isSm.value"
      class="account-side-menu-outer"
      @click="drawer = false"
    >
      <nav
        class="account-side-menu"
        :class="{ 'account-side-menu-closed': !drawer }"
        @click.stop
      >
        <div class="account-side-menu__outer">
          <div v-for="(item, i) in items" :key="i">
            <div v-if="item.children">
              <div
                class="account-side-menu__item"
                :class="{ 'account-side-menu-active-item': expanded === i }"
                @click="handleExpand(i), (drawer = true)"
              >
                <div class="account-side-menu__inner">
                  <span
                    v-if="item.icon"
                    class="account-side-menu__icon"
                    :class="item.icon"
                  />
                  <span class="account-side-menu__text">
                    {{ item.text }}
                  </span>
                </div>
                <span class="account-side-menu__arrow icon-down" />
              </div>
              <div
                class="account-side-menu__children"
                :class="{ 'account-side-menu__expanded': expanded === i }"
              >
                <transition name="fade">
                  <span
                    v-if="item.children.find((child) => child.selected)"
                    class="children-line"
                    :style="`height: ${100 / item.children.length}%; top: ${
                      (100 / item.children.length) *
                      item.children.findIndex((child) => child.selected)
                    }%;`"
                  />
                </transition>
                <NuxtLink
                  v-for="(child, k) in item.children"
                  :key="k"
                  :to="child.to"
                  class="account-side-menu__child"
                  @click="selectChild(i, k)"
                >
                  {{ child.text }}
                </NuxtLink>
              </div>
            </div>
            <NuxtLink
              v-else
              :to="item.to"
              class="account-side-menu__item"
              @click="resetChilds(), (drawer = true)"
            >
              <div class="account-side-menu__inner">
                <span
                  v-if="item.icon"
                  class="account-side-menu__icon"
                  :class="item.icon"
                />
                <span class="account-side-menu__text">
                  {{ item.text }}
                </span>
              </div>
            </NuxtLink>
          </div>
        </div>
      </nav>
    </div>
  </transition>
</template>

<script>
import { mapWritableState } from 'pinia'
import { appStore } from '@/stores/app'

export default {
  props: {
    items: {
      type: Array,
      require: false,
      default: () => [],
    },
  },
  computed: {
    ...mapWritableState(appStore, ['drawer']),
  },
  watch: {
    '$isSm.value'() {
      this.drawer = false
    },
  },
  data() {
    return {
      expanded: Number,
    }
  },
  created() {
    this.items.forEach((item) => {
      if (item.children)
        item.children.forEach((child) => {
          if (this.$route.path === child.to) {
            child.selected = true
          }
        })
    })
  },
  mounted() {
    console.log(this.$isSm)
  },
  methods: {
    handleExpand(index) {
      this.expanded = this.expanded === index ? -1 : index
    },
    resetChilds() {
      this.items.forEach((item) => {
        if (item.children)
          item.children.forEach((child) => (child.selected = false))
      })
    },
    selectChild(parentIndex, childIndex) {
      this.resetChilds()
      this.items[parentIndex].children[childIndex].selected = true
    },
  },
}
</script>

<style lang="scss" scoped>
.account-side-menu-outer {
  height: 100%;
}
.account-side-menu {
  background-color: white;
  height: 100%;
  width: 16.4rem;
  padding: 1rem 0.95rem;
  -webkit-user-select: none; /* Safari */
  -moz-user-select: none; /* Firefox */
  -ms-user-select: none; /* IE10+/Edge */
  user-select: none; /* Standard */
  transition: width 0.2s ease;
  &__outer {
    position: sticky;
    top: 0;
  }
  &__item {
    padding: 1rem 1.1rem;
    color: $--color-neutral-900;
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: pointer;
    transform: all 0.3s ease;
    border-radius: 0.3rem;
  }
  &__icon {
    font-size: 1.1rem;
    color: $--color-neutral-500;
  }
  &__text {
    font-size: 0.9rem;
    margin: 0 1.1rem;
    line-height: 1.56rem;
  }
  &__inner {
    display: flex;
    align-items: center;
    white-space: nowrap;
  }
  &__arrow {
    color: #c8c7c6;
  }
  &__children {
    padding-right: 1.9rem;
    max-height: 0;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
    position: relative;
    &::before {
      content: ' ';
      position: absolute;
      width: 3px;
      right: 0.8rem;
      top: 0;
      bottom: 0;
      background-color: #f6f6f6;
    }
  }
  &__child {
    display: block;
    color: $--color-neutral-900;
    font-size: 0.9rem;
    padding: 0.7rem 0;
    cursor: pointer;
    transition: all 0.2s linear;
    white-space: nowrap;
  }
  &__expanded {
    max-height: 1000px;
    height: auto;
    margin: 1.3rem 0;
  }
}
.account-side-menu-active-item {
  .account-side-menu__icon,
  .account-side-menu__text,
  .account-side-menu__arrow {
    color: $--color-primary;
  }
  background-color: $__color-secondary-50;
}

.router-link-exact-active {
  color: $--color-primary;
  .account-side-menu__icon,
  .account-side-menu__text {
    color: $--color-primary;
  }
  &.account-side-menu__item {
    background-color: $__color-secondary-50;
  }
}
@media (min-width: 48em) {
  .account-side-menu-closed {
    width: 4.38rem;
    overflow: hidden;
    .account-side-menu__item {
      background-color: transparent;
    }
    .account-side-menu__text {
      margin-right: 2rem;
    }
    .account-side-menu__item {
      padding: 1rem 0.7rem;
    }
    .account-side-menu__icon {
      color: #221d1c;
    }
    .account-side-menu__children {
      margin: 0;
      max-height: 0;
      overflow: hidden;
    }
  }
}

.children-line {
  background-color: $--color-primary;
  width: 3px;
  position: absolute;
  right: 0.8rem;
  top: 0;
  transition: top 0.2s ease;
}

@media (max-width: 48em) {
  .account-side-menu-outer {
    position: fixed;
    opacity: 1;
    transition: opacity 0.5s ease;
    top: 0;
    right: 0;
    left: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.24);
    z-index: 1000;
  }
  .account-side-menu {
    position: absolute;
    right: 0;
    transition: right 0.3s;
    background-color: white;
    height: 100%;
    width: 90%;
    max-width: 17rem;
    padding: 0;
    &__outer {
      position: relative;
    }
    &__text {
      font-size: 0.85rem;
    }
    &__children {
      padding-right: 1.9rem;
      &::before {
        width: 2px;
      }
    }
    &__child {
      font-size: 0.85rem;
      padding: 0.6rem 0;
    }
    &__expanded {
      max-height: 1000px;
      height: auto;
      margin: 1rem 0;
    }
  }
  .children-line {
    width: 2px;
  }
}

.right-shift-enter-active,
.right-shift-leave-active {
  transition: opacity 0.3s ease;
}

.right-shift-enter-from,
.right-shift-leave-to {
  opacity: 0;
  .account-side-menu {
    right: -100%;
  }
}
</style>
