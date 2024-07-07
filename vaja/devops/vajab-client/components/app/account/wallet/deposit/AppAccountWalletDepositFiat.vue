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
        <g-input
          :model-value="$filters.toCurrency(deposit.value)"
          label="مبلغ واریزی"
          top-label
          class="mb-2"
          autocomplete="off"
          maxlength="16"
          type="tel"
          @input="changeFiatAmount"
        >
          <template #appended> تومان </template>
        </g-input>
        <g-row :gutter="25">
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">کارمزد واریز</span>
              <span class="text-regular-5"
                >{{ $filters.toCurrency(0) }} تومان</span
              >
            </div>
          </g-col>
          <g-col :xs="12">
            <div class="asset-hint">
              <span class="text-sm-2">مبلغ واریز به کیف پول</span>
              <span class="text-regular-5"
                >{{ $filters.toCurrency(40000) }} تومان</span
              >
            </div>
          </g-col>
        </g-row>
      </div>
    </div>
    <g-btn class="w-100"> تایید و انتقال به درگاه بانک </g-btn>
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
          cardNumber: '5029081058996980',
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
.gray-box {
  background-color: #f6f6f6;
  border-radius: $--border-radius-base;
  padding: 1.5rem 1rem;
  margin-bottom: 1.7rem;
  &__inner {
    max-width: 41.5rem;
    margin: 0 auto;
  }
}
</style>
