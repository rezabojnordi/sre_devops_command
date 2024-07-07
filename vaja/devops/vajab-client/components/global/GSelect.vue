<template>
  <div>
    <div ref="select" class="g-select">
      <slot v-if="$slots.wrapper" name="wrapper" />
      <div
        v-else
        class="g-select__select-box"
        :class="{ 'g-select__select-box-open': openFlag }"
        @click="openFlag = !openFlag"
      >
        <span v-if="$slots.title && modelValue">
          <slot name="title" v-bind="modelValue" />
        </span>
        <span v-else-if="modelValue">{{ modelValue[label] }}</span>
        <span v-else class="g-select__placeholder"> {{ placeholder }}</span>
        <span
          class="g-select__arrow icon-down"
          :style="openFlag ? 'transform: rotate(180deg);' : ''"
        ></span>
      </div>

      <div
        tabindex="-1"
        class="g-select__content-wrapper"
        :class="{ 'g-select__content-wrapper-open': openFlag }"
      >
        <div v-if="hasSearch" class="g-select__search">
          <g-input
            v-model="search"
            maxlength="100"
            type="text"
            icon="icon-search-normal"
            placeholder="جستجو کنید"
            :filled="true"
            :no-error="true"
          />
        </div>
        <div class="g-select__content-wrapper-inner">
          <ul v-if="items.length" role="listbox" class="g-select__content">
            <li
              v-for="(item, i) in items"
              :key="i"
              role="option"
              :class="{
                'g-select__element': !$slots.item,
                'g-select__active': selectedItems.find(
                  (value) => value[keyName] === item[keyName]
                ),
                'g-select__no-border': noBorder,
              }"
              @click="select(item)"
            >
              <span v-if="$slots.item">
                <slot
                  name="item"
                  v-bind="{
                    ...item,
                    selectIndex: i,
                  }"
                />
              </span>
              <div v-else>
                <span>{{ item[label] }}</span>
              </div>
            </li>
          </ul>
          <div v-else class="text-center text-light text-regular-5">
            موردی برای نمایش وجود ندارد
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    modelValue: {
      type: [Object],
      required: true,
      default: () => {},
    },
    title: {
      type: String,
      require: false,
      default: '',
    },
    label: {
      type: String,
      required: true,
      default: 'title',
    },
    keyName: {
      type: String,
      require: false,
      default: 'title',
    },
    placeholder: {
      type: String,
      required: false,
      default: 'لطفا گزینه مورد نظر خود را انتخاب کنید',
    },
    multiSelect: {
      type: Boolean,
      required: false,
      default: false,
      // dont touch this! just left it alone!
    },
    hasSearch: {
      type: Boolean,
      required: false,
      default: false,
    },
    searchTerm: {
      type: String,
      required: false,
      default: '',
    },
    items: {
      type: Array,
      required: false,
      default: () => [],
    },
    noBorder: {
      type: Boolean,
      required: false,
      default: false,
      // dont touch this! just left it alone!
    },
  },
  emits: ['update:modelValue'],
  data() {
    return {
      expanded: false,
      openFlag: false,
      selectedItems: [],
    }
  },
  computed: {
    search: {
      get() {
        return this.searchTerm
      },
      set(newValue) {
        this.$emit('update:searchTerm', newValue)
      },
    },
  },
  watch: {
    value() {
      this.setSelected()
    },
  },
  mounted() {
    document.addEventListener('click', this.handleClick)
  },
  unmounted() {
    document.removeEventListener('click', this.handleClick)
  },
  methods: {
    handleClick(event) {
      if (this.$refs.select) {
        if (!this.$refs.select.contains(event.target)) {
          this.openFlag = false
        }
      }
    },
    setSelected() {
      this.selectedItems = []
      if (Array.isArray(this.modelValue)) {
        this.selectedItems = this.modelValue
      } else if (this.modelValue) {
        this.selectedItems.push(this.modelValue)
      }
    },
    select(val) {
      const index = this.selectedItems.findIndex((value) => value === val)
      if (this.multiSelect) {
        if (index < 0) {
          this.selectedItems.push(val)
        } else {
          this.selectedItems.splice(index, 1)
        }
        this.$emit('update:modelValue', this.selectedItems)
      } else {
        if (index < 0) {
          this.selectedItems = []
          this.selectedItems.push(val)
          this.$emit('update:modelValue', val)
        } else {
          this.selectedItems.splice(index, 1)
          this.$emit('update:modelValue', null)
        }
      }
      this.openFlag = false
    },
  },
}
</script>

<style lang="scss" scoped>
.g-select {
  position: relative;
  -webkit-user-select: none; /* Safari */
  -moz-user-select: none; /* Firefox */
  -ms-user-select: none; /* IE10+/Edge */
  user-select: none; /* Standard */
  &__title {
    color: $--color-neutral-900;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
  }
  &__select-box {
    font-size: 0.9rem;
    padding: 0 0.9rem;
    color: $--color-neutral-900;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background-color: $--color-white;
    border: 1px solid $--border-color-base;
    border-radius: 0.5rem;
    cursor: pointer;
    height: 45px;
  }
  &__select-box-open {
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
    border-bottom: 0;
  }
  &__arrow {
    font-size: 1rem;
    transition: all 0.3s;
    color: $--color-neutral-500;
  }
  &__content-wrapper {
    visibility: hidden;
    opacity: 0;
    position: absolute;
    right: 0;
    left: 0;
    background-color: $--color-white;
    padding: 0 0.5rem;
    box-shadow: 0px 8px 12px rgba(26, 26, 26, 0.12);
    border-bottom-right-radius: 0.5rem;
    border-bottom-left-radius: 0.5rem;
    z-index: 100;
    border: 1px solid $--border-color-base;
  }
  &__content-wrapper-inner {
    direction: ltr;
    max-height: 10.6rem;
    overflow-y: auto;
    padding: 0 0.5rem;
    margin: 0.8rem 0;
    &::-webkit-scrollbar-thumb {
      border-radius: 10px;
      background-color: #c8c7c6;
    }

    &::-webkit-scrollbar-track {
      background-color: #ededed;
    }

    &::-webkit-scrollbar {
      display: inline-block;
      margin-left: -10px;
      width: 3px;
      background-color: transparent;
    }
  }
  &__content-wrapper-open {
    visibility: visible;
    opacity: 1;
  }
  &__content {
    padding: 0;
    margin: 0;
    direction: rtl;
  }
  li {
    list-style: none;
    cursor: pointer;
    padding: 0.4rem 0;
  }
  &__element {
    border-bottom: 1px solid $--border-color-base;
    line-height: 1.6rem;
    font-weight: 700;
    display: block;
    font-size: 0.8rem;
    color: $--color-neutral-300;
    &:first-of-type {
      padding-top: 0;
    }
    &:last-of-type {
      padding-bottom: 0;
      border-bottom: 0;
    }
  }
  &__no-border {
    border-bottom: 0;
  }
  &__placeholder {
    color: $--color-neutral-300;
    font-size: 0.8rem;
  }
  &__active {
    color: $--color-primary;
  }
  &__search {
    margin-top: 0.95rem;
    padding: 0 0.5rem;
  }
}
</style>
