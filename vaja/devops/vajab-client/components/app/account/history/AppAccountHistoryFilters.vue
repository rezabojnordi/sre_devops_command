<template>
  <div>
    <g-row :gutter="30">
      <g-col>
        <UtilitiesMenuDropdown event="click" :top-margin="10" min-width="190px">
          <template #title>
            <g-btn class="filter-btn" outlined>
              <span class="icon-calendar filter-btn__icon"></span>
              <span> انتخاب بازه زمانی </span>
            </g-btn>
          </template>
          <template #body>
            <g-row class="mb-3 mt-2" alignment="center" :gutter="20">
              <g-col>
                <span class="text-sm-3 text-light"> از تاریخ </span>
              </g-col>
              <g-col flex-1>
                <g-input
                  id="from-date"
                  filled
                  maxlength="20"
                  :model-value="
                    $filters.jalaliMoment(fromDate, 'jYYYY-jMM-jDD')
                  "
                  no-error
                >
                  <template #appended>
                    <span class="icon-calendar"></span>
                  </template>
                </g-input>
              </g-col>
            </g-row>
            <g-row class="mb-3" alignment="center" :gutter="20">
              <g-col>
                <span class="text-sm-3 text-light"> از تاریخ </span>
              </g-col>
              <g-col flex-1>
                <g-input
                  id="to-date"
                  filled
                  maxlength="20"
                  :model-value="$filters.jalaliMoment(toDate, 'jYYYY-jMM-jDD')"
                  no-error
                >
                  <template #appended>
                    <span class="icon-calendar"></span>
                  </template>
                </g-input>
              </g-col>
            </g-row>
            <div class="divider"></div>
            <g-btn class="w-100" @click="submitDate()">
              اعمال بازه زمانی
            </g-btn>
          </template>
        </UtilitiesMenuDropdown>
      </g-col>

      <g-col flex-1>
        <g-select
          v-model="filters.currency"
          v-model:searchTerm="searchTerm"
          title="رمز ارز خود را انتخاب نمایید"
          placeholder="ارز مورد نظر خود برای واریز را انتخاب کنید"
          key-name="currency"
          no-border
          has-search
          :items="
            coins.filter(
              (item) =>
                item.currency
                  .toLowerCase()
                  .includes(searchTerm.toLowerCase()) ||
                item.title.toLowerCase().includes(searchTerm.toLowerCase())
            )
          "
        >
          <template #title="item">
            <div class="coin-select-item">
              <div class="coin-select-item__inner">
                <img
                  src="~/assets/images/account/BTC.svg"
                  :alt="item.currency"
                />
                <span class="coin-select-item__title text-title-5">{{
                  item.title
                }}</span>
                <span class="text-light">{{ item.currency }}</span>
              </div>
              <div class="text-regular-4 text-light">
                {{ item.selectIndex }}
              </div>
            </div>
          </template>
          <template #item="item">
            <div class="coin-select-item">
              <div class="coin-select-item__inner">
                <img
                  src="~/assets/images/account/BTC.svg"
                  :alt="item.currency"
                />
                <span class="coin-select-item__title text-title-5">{{
                  item.title
                }}</span>
                <span class="text-light">{{ item.currency }}</span>
              </div>
              <div class="text-regular-4 text-light">
                {{
                  ('0' + item.selectIndex).slice(
                    -(item.selectIndex.length > 1 ? item.selectIndex.length : 2)
                  )
                }}
              </div>
            </div>
          </template>
        </g-select>
      </g-col>
    </g-row>
    <date-picker
      v-model="fromDate"
      element="from-date"
      format="YYYY-MM-DD"
      color="#45A8C2"
      view="year"
      :min="
        new Date(
          new Date().setFullYear(new Date().getFullYear() - 100)
        ).toJSON()
      "
      :max="
        new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toJSON()
      "
    />
    <date-picker
      v-model="toDate"
      element="to-date"
      format="YYYY-MM-DD"
      color="#45A8C2"
      view="year"
      :min="
        new Date(
          new Date().setFullYear(new Date().getFullYear() - 100)
        ).toJSON()
      "
      :max="
        new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toJSON()
      "
    />
  </div>
</template>

<script lang="ts">
export default {
  props: {
    coins: {
      type: Array,
      default: () => [],
      require: false,
    },
  },
  emits: ['change'],
  data() {
    return {
      searchTerm: '',
      toDate: '',
      fromDate: '',
      filters: {
        fromDate: '',
        toDate: '',
        currency: '',
      },
    }
  },
  watch: {
    filters() {
      this.$emit('change', this.filters)
    },
  },
  methods: {
    submitDate() {
      this.filters.fromDate = this.fromDate
      this.filters.toDate = this.toDate
    },
  },
}
</script>

<style lang="scss" scoped></style>
