<template>
  <div>
    <div class="gray-box">
      <div class="gray-box__inner">
        <div class="account-form-item">
          <div class="g-justify-space-between g-row mb-3">
            <span class="text-sm-2">کارت بانکی خود را انتخاب نمایید</span>
            <span class="text-regular-5">
              <router-link to="/account/bankcards">
                <div class="color-base">
                  <span class="icon-add-square mx-2 vertical-middle"></span>
                  افزودن کارت بانکی جدید
                </div>
              </router-link>
            </span>
          </div>
          <g-select
            v-model="deposit.selectedCard"
            title="کارت بانکی"
            placeholder="کارت بانکی مورد نظر را انتخاب کنید"
            key-name="cardNumber"
            :items="bankCards"
          >
            <template #title="item">
              <div class="text-regular-5 card-number-item">
                <img
                  :src="useBankcards(item.cardNumber).logo"
                  :alt="useBankcards(item.cardNumber).name"
                />
                <span class="card-number-item__name">
                  {{ useBankcards(item.cardNumber).name }}
                </span>
                <b class="rtl-nums">
                  {{ formatBankcard($filters.cardNumberMask(item.cardNumber)) }}
                </b>
              </div>
            </template>
            <template #item="item">
              <div class="text-regular-5 card-number-item">
                <img
                  :src="useBankcards(item.cardNumber).logo"
                  :alt="useBankcards(item.cardNumber).name"
                />
                <span class="card-number-item__name">
                  {{ useBankcards(item.cardNumber).name }}
                </span>
                <b class="rtl-nums">
                  {{ formatBankcard($filters.cardNumberMask(item.cardNumber)) }}
                </b>
              </div>
            </template>
          </g-select>
        </div>
        <div class="g-justify-space-between g-row mb-3">
          <span class="text-sm-2">مقدار برداشتی</span>
          <span class="text-regular-5"> قابل برداشت: ۰ تومان </span>
        </div>
        <g-row :gutter="15">
          <g-col flex-1>
            <g-input
              :model-value="$filters.toCurrency(deposit.value)"
              class="mb-2"
              autocomplete="off"
              maxlength="16"
              type="tel"
              @input="changeFiatAmount"
            >
              <template #appended> تومان </template>
            </g-input>
          </g-col>
          <g-col>
            <g-btn class="all-amount-btn"> کل موجودی </g-btn>
          </g-col>
        </g-row>
        <g-row :gutter="25">
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">کارمزد درگاه</span>
              <span class="text-regular-5"
                >{{ $filters.toCurrency(40000) }} تومان</span
              >
            </div>
          </g-col>
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">مبلغ برداشت از کیف پول</span>
              <span class="text-regular-5"
                >{{ $filters.toCurrency(40000) }} تومان</span
              >
            </div>
          </g-col>
        </g-row>
      </div>
    </div>
    <div class="text-center color-warning text-sm-2 my-4">
      وجه درخواستی در ساعت 4:00 الی 7:00 صبح شنبه 1401/09/26 واریز خواهد شد.
    </div>
    <g-btn class="w-100" @click="$emit('submit')"> درخواست برداشت </g-btn>
  </div>
</template>

<script lang="ts">
export default {
  data() {
    return {
      deposit: {
        selectedCard: null,
        value: '',
      },
      bankCards: [
        {
          cardNumber: '6274126545445444',
        },
        {
          cardNumber: '6104338945895171',
        },
      ],
    }
  },
  methods: {
    changeFiatAmount(e: string) {
      if (e) {
        e = this.$filters.toEn(e)
      }
      const regex = /^[1-9]\d*(\.\d+)?$/
      if (regex.test(e.replace(/,/g, '')) || !e) {
        this.deposit.value = e.replace(/,/g, '')
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.asset-hint {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #ededed;
  border-radius: $--border-radius-base;
  padding: 0.875rem 1.2rem;
}
.account-form-item {
  margin-bottom: 1.2rem;
}
</style>
