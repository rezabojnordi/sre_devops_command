<template>
  <div>
    <g-row :gutter="30">
      <g-col :xs="12">
        <div class="kyc-info-card">
          <div class="kyc-info-card__head">
            <div class="kyc-info-card__title">
              گام دوم : لطفا مشخصات خود را تکمیل نمایید
            </div>
          </div>
          <div class="kyc-info-card__body">
            <!-- choosing type of national card image -->
            <UtilitiesRadioButtonGroup
              v-model="selectedFileType"
              :items="radioItems"
              class="mb-4"
            />

            <Form
              v-if="selectedFileType.value === 1"
              v-slot="{ errors }"
              :validation-schema="docFilesSchema"
              @submit="submitDocNatType()"
            >
              <Field v-slot="{ field }" name="frontNatFile">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="docs.frontNatFile"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    عکس روی کارت ملی
                  </div>
                  <utilities-file-input
                    v-model="docs.frontNatFile"
                    class="lable-input-group__input"
                    placeholder="انتخاب نشده"
                    :error="errors.frontNatFile"
                    v-bind="field"
                    accept="image/jpeg,jpg,png"
                  />
                </div>
              </Field>

              <Field v-slot="{ field }" name="backNatFile">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="docs.backNatFile"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    عکس پشت کارت ملی
                  </div>
                  <utilities-file-input
                    v-model="docs.backNatFile"
                    class="lable-input-group__input"
                    placeholder="انتخاب نشده"
                    :error="errors.backNatFile"
                    v-bind="field"
                    accept="image/jpeg,jpg,png"
                  />
                </div>
              </Field>
            </Form>

            <Form
              v-else
              v-slot="{ errors }"
              :validation-schema="docCertificateSchema"
              @submit="submitDocNatType()"
            >
              <Field v-slot="{ field }" name="certificateFile">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="docs.certificateFile"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    صفحه اول شناسنامه
                  </div>
                  <utilities-file-input
                    v-model="docs.certificateFile"
                    class="lable-input-group__input"
                    placeholder="انتخاب نشده"
                    :error="errors.certificateFile"
                    v-bind="field"
                    accept="image/jpeg,jpg,png"
                  />
                </div>
              </Field>

              <Field v-slot="{ field }" name="natCardTrackCode">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="docs.natCardTrackCode?.length === 10"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    کد پیگیری کارت ملی
                  </div>
                  <g-input
                    v-model="docs.natCardTrackCode"
                    placeholder="کد پیگیری را وارد نمایید"
                    filled
                    maxlength="10"
                    type="tel"
                    autocomplete="off"
                    :error="errors.natCardTrackCode"
                    v-bind="field"
                    class="lable-input-group__input"
                  />
                </div>
              </Field>
            </Form>
          </div>
        </div>
        <g-btn
          class="mt-4 w-100"
          :loading="loading"
          @click="
            selectedFileType.value === 1
              ? submitDocNatType()
              : submitDocCertificateType()
          "
          >ثبت و مشاهده گام نهایی</g-btn
        >
      </g-col>
      <g-col :xs="12">
        <app-account-attention-notes
          :items="attentionItems"
          title="نکات مهم احرازهویت"
        />
      </g-col>
    </g-row>
  </div>
</template>

<script lang="ts">
export default {
  data() {
    return {
      loading: false,
      selectedFileType: {
        label: 'کارت ملی دارم',
        value: 1,
      },
      radioItems: [
        {
          label: 'کارت ملی دارم',
          value: 1,
        },
        {
          label: 'کارت ملی ندارم',
          value: 2,
        },
      ],
      step: 1,
      docFilesSchema: {
        backNatFile: 'require',
        frontNatFile: 'require',
      },
      docCertificateSchema: {
        certificateFile: 'require',
        frontNatFile: 'require',
      },
      docs: {
        frontNatFile: undefined,
        backNatFile: undefined,
        certificateFile: undefined,
        natCardTrackCode: '',
      },
      attentionItems: [
        {
          text: 'مدرک شناسایی حتما باید معتبر بوده و به نام خودتان باشد.درصورتی که تغییراتی در اطلاعات هویتی داشته اید ولی در کارت ملی یا سامانه بانکداری ثبت نشده است،تصویر توضیحات شناسنامه که تغییرات در آن ذکر شده است را آپلود کنید.',
        },
      ],
    }
  },
  watch: {
    selectedFileType() {
      this.docs = {
        frontNatFile: undefined,
        backNatFile: undefined,
        certificateFile: undefined,
        natCardTrackCode: '',
      }
    },
  },
  methods: {
    submitDocNatType() {
      alert('okkkk')
    },
    submitDocCertificateType() {
      alert('cardNum!!')
    },
  },
}
</script>

<style lang="scss" scoped>
.file-label-input-group {
  &__label {
    min-width: 156px !important;
  }
  &__icon {
    margin-left: 0.7rem;
    color: #c8c7c6;
    font-size: 1rem;
  }
  &__icon-active {
    color: $--color-success-300;
  }
}
</style>
