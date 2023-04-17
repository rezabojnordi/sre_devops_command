<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="false"
      class="profile-account-card"
    >
      <g-row :gutter="30">
        <g-col :xs="24" :lg="10">
          <g-row :gutter="10" :y-gutter="10" class="internal-deposit__info">
            <g-col
              :xs="24"
              :lg="5"
              :offset-xs="1"
              class="internal-deposit__info__qrcode"
            >
              <img src="~/assets/images/download/qrcode.svg" alt="" />
            </g-col>
            <g-col
              :xs="24"
              :lg="18"
              class="internal-deposit__info__inputs text-title-5"
            >
              <div>
                <span>سطح یک</span>
                <span>محمد باقر علی رضایی نژاد بجستانی</span>
              </div>
              <div class="mt-2">
                <span>شناسه دریافت آنی</span>
                <span>{{ identifyNumber }}</span>
                <span class="icon-copy" @click="copy(identifyNumber)"></span>
              </div>
            </g-col>
          </g-row>
          <hr />
          <AppAccountPayCheckbox
            class="internal-deposit__select-box mb-2"
            title="تبدیل خودکار به تتر"
            sub-title="پرداخت های تومانی به صورت خودکار به تتر تبدیل شود"
            pre-icon="icon-coin-convert"
          ></AppAccountPayCheckbox>
          <AppAccountPayCheckbox
            class="internal-deposit__select-box mb-2"
            title="تبدیل خودکار به تومان"
            sub-title="پرداخت های تومانی به صورت خودکار به تتر تبدیل شود"
            pre-icon="icon-coin-convert"
          ></AppAccountPayCheckbox>
          <g-row :gutter="10" :y-gutter="10">
            <g-col :xs="24" :lg="14">
              <div class="vajab-card">
                <div>
                  <span class="flex-grow-1">صرافی ارز دیجیتال وجب</span>
                  <span class="mx-2">Vajab.ir</span>
                  <img src="~/assets/images/account/card-tag.svg" alt="" />
                </div>
                <div>
                  <span>شناسه دریافت آنی</span>
                  <span>5132-5147-9541-0384</span>
                </div>
                <div>
                  <span>محمد باقر علی رضایی نژاد بجستانی</span>
                </div>
              </div>
            </g-col>
            <g-col class="internal-deposit__btns" :xs="24" :lg="10">
              <g-btn class="internal-deposit__btns__btn w-100" plain
                >ذخیره و دانلود کارت</g-btn
              >
              <g-btn class="internal-deposit__btns__btn w-100" plain
                >اشتراک گذاری کارت</g-btn
              >
              <g-btn
                class="internal-deposit__btns__btn w-100 flex-grow-1"
                plain
              >
                <div class="internal-deposit__btns__btn__share">
                  <span class="icon-scan-barcode"></span>
                  <span>اشتراک گذاری QR</span>
                </div>
              </g-btn>
            </g-col>
          </g-row>
        </g-col>
        <g-col :xs="24" :lg="12">
          <app-account-attention-notes :items="attentionItems" title="راهنما" />
        </g-col>
      </g-row>
    </AppAccountCard>
  </div>
</template>

<script setup lang="ts">
const { $toast } = useNuxtApp()

const path = ref({
  parent: 'پرداخت',
  child: 'شناسه دریافت آنی',
})
const attentionItems = ref([
  {
    text: 'حتماً به آدرس صفحه‌ی درگاه بانکی دقت نموده و تنها پس از اطمینان از حضور در سایت‌های سامانه‌ی شاپرک مشخصات کارت بانکی خود را وارد نمایید.',
  },
  {
    text: 'در صفحه درگاه دقت کنید که حتما مبلغ نمایش داده شده درست باشد.',
  },
  {
    text: 'در تعیین مبلغ واریز به این موضوع دقت نمایید که حداقل مبلغ معامله در بازار وجب 300,000 تومان است.',
  },
  {
    text: 'سقف واریز تومانی برای سطح کاربری یک، م بلغ پانصد هزار تومان در هر ۲۴ ساعت است.',
  },
])
const identifyNumber = ref<string>('5132-5147-9541-0384')
const { text, copy, copied, isSupported } = useClipboard({
  source: identifyNumber,
})
const permissionRead = usePermission('clipboard-read')
const permissionWrite = usePermission('clipboard-write')

watch(copied, (val) => {
  if (val) $toast.success('کپی شد.')
})
</script>

<style lang="scss" scoped>
.internal-deposit {
  &__info {
    display: flex;
    justify-content: center;
    align-items: center;
    &__qrcode {
      text-align: center;
      & > img {
        width: 100%;
        max-width: 200px;
      }
    }
    &__inputs {
      flex-grow: 1;
      & > div {
        border: 1px solid $--border-color-base;
        border-radius: $--border-radius-base;
        display: flex;
        align-items: center;
        span {
          padding: 0.5rem;
          &:nth-child(1) {
            border-left: 1px solid $--border-color-base;
            width: 10rem;
            color: $--color-neutral-300;
          }
          &:nth-child(2) {
            text-align: center;
            flex-grow: 1;
          }
        }
        .icon-copy {
          cursor: pointer;
        }
      }
    }
  }
  &__select-box {
    background-color: $--color-neutral-20;
    display: flex;
    align-items: center;
    align-items: center;
    padding: 1rem;
    border-radius: $--border-radius-base;
    gap: 0.5rem;
  }
  &__btns {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    &__btn {
      background-color: #edf4f5;
      &__share {
        display: flex;
        flex-direction: column;
      }
    }
  }
}
.vajab-card {
  background: url('~/assets/images/account/vajab-card-pattern.svg') #45a8c2
    center center;
  padding: 2rem;
  border-radius: $--border-radius-lg;
  //height: 15rem;
  width: 100%; // 27 / 15
  aspect-ratio: 27 / 15;
  font-weight: 700;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  & > div {
    display: flex;
    justify-content: space-between;
    align-items: center;
    &:nth-child(1) {
      color: $--color-white;
    }
    &:nth-child(2) {
      background: linear-gradient(
        90.84deg,
        rgba(0, 0, 0, 0.33) 0.16%,
        rgba(30, 54, 61, 0.42) 95.35%
      );
      padding: 0.5rem;
      border-radius: $--border-radius-base;
      color: $--color-white;
    }
    &:nth-child(3) {
      justify-content: center;
      text-align: center;
      width: 100%;
    }
  }
}
</style>
