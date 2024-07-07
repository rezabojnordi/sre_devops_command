<template>
  <g-dialog
    :model-value="modelValue"
    :max-width="380"
    @update:modelValue="emit('update:modelValue', $event)"
  >
    <div class="select-coin">
      <div class="select-coin__header">
        <span class="text-sm-2">{{ header }}</span>
        <span
          class="icon-close-square"
          @click="emit('update:modelValue', false)"
        ></span>
      </div>
      <div class="select-coin__search">
        <g-input
          v-model="searchInput"
          class="w-100"
          no-error
          top-label
          filled
          placeholder="جستجو در ارز ها ..."
        >
          <template #prepended>
            <span class="icon-search-normal"></span>
          </template>
        </g-input>
      </div>
      <div
        v-bind="containerProps"
        style="height: 240px"
        class="select-coin__main"
      >
        <div v-bind="wrapperProps">
          <div
            v-for="item in list"
            :key="item.index"
            class="select-coin__item"
            style="height: 48px"
            @click="selectCoin(item.data)"
          >
            <img :src="item.data.img" alt="" />
            <span class="text-sm-2">{{ item.data.name_fa }}</span>
            <span class="text-regular-5">( {{ item.data.symbol }} )</span>
            <span class="text-sm-2">{{ item.data.name }}</span>
          </div>
        </div>
      </div>
    </div>
  </g-dialog>
</template>

<script setup lang="ts">
import { SelectCoinInterface } from '~/types/otc/select.coin.interface'

/**
 * interfaces
 * **/
interface SelectCoinPropsInterface {
  coins: Array<SelectCoinInterface>
  modelValue: boolean
  header: string
}

const searchInput = ref<string>('')

const props = withDefaults(defineProps<SelectCoinPropsInterface>(), {
  coins: () => [],
  modelValue: false,
  header: 'انتخاب ارز',
})
const emit = defineEmits<{
  (e: 'select', symbol: SelectCoinInterface): void
  (e: 'update:modelValue', modelValue: boolean): void
}>()

const filteredSource = computed(() => {
  if (!searchInput.value) return props.coins
  return props.coins.filter((item) =>
    Object.values(item).some((val) => {
      return val
        .toString()
        .toLowerCase()
        .includes(searchInput.value.toLowerCase())
    })
  )
})

const { list, containerProps, wrapperProps } = useVirtualList(filteredSource, {
  itemHeight: 48,
})

const selectCoin = (symbol: SelectCoinInterface) => {
  emit('select', symbol)
}
</script>

<style scoped lang="scss">
.select-coin {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 23rem;
  gap: 1rem;
  &__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 2rem;
    .icon-close-square {
      cursor: pointer;
    }
  }
  &__search {
    display: flex;
    height: 4rem;
    align-items: center;
  }
  &__main {
  }
  &__item {
    cursor: pointer;
    display: flex;
    align-items: center;
    padding: 0 0.5rem;
    gap: 0.5rem;
    img {
      width: 2rem;
      height: 2rem;
      border-radius: $--border-radius-small;
    }
    span {
      &:nth-child(2) {
        flex-grow: 1;
      }
    }
  }
}
</style>

<!--<script setup lang="ts">-->
<!--import { useVirtualList, useToggle } from '@vueuse/core'-->
<!--import { computed } from 'vue'-->

<!--const [isEven, toggle] = useToggle()-->
<!--const allItems = Array.from(Array(99999).keys())-->
<!--const filteredList = computed(() =>-->
<!--  allItems.filter((i) => (isEven.value ? i % 2 === 0 : i % 2 === 1))-->
<!--)-->

<!--const { list, containerProps, wrapperProps } = useVirtualList(filteredList, {-->
<!--  itemHeight: 22,-->
<!--})-->
<!--</script>-->

<!--<template>-->
<!--  <p>Showing {{ isEven ? 'even' : 'odd' }} items</p>-->
<!--  <button @click="toggle">Toggle Even/Odd</button>-->
<!--  <div v-bind="containerProps" style="height: 300px">-->
<!--    <div v-bind="wrapperProps">-->
<!--      <div v-for="item in list" :key="item.index" style="height: 22px">-->
<!--        Row: {{ item.data }}-->
<!--      </div>-->
<!--    </div>-->
<!--  </div>-->
<!--</template>-->
