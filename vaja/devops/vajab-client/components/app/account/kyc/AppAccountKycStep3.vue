<template>
  <div>
    <g-row :gutter="30">
      <g-col :xs="12">
        <div class="kyc-info-card">
          <div class="kyc-info-card__head">
            <div class="kyc-info-card__title">گام نهایی، سلفی</div>
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
              :validation-schema="selfieSchema"
              @submit="submitDocNatType()"
            >
              <div class="attention-text-warning text-center mb-4">
                ویدئو سلفی مناسب افرادی است که کارت ملی هوشمند دارند
              </div>
              <Field v-slot="{ field }" name="frontNatFile">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="selfie.video"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    ویدئو سلفی
                  </div>
                  <utilities-file-input
                    v-model="selfie.video"
                    class="lable-input-group__input"
                    placeholder="انتخاب نشده"
                    accept="video/*"
                    :error="errors.video"
                    v-bind="field"
                  />
                </div>
              </Field>
            </Form>

            <Form
              v-else
              v-slot="{ errors }"
              :validation-schema="selfieSchema"
              @submit="submitDocNatType()"
            >
              <div class="attention-text-warning text-center mb-4">
                فرمت های مجاز تصاویر : jpeg, jpg, png
              </div>
              <Field v-slot="{ field }" name="image">
                <div class="lable-input-group label-input-file">
                  <div
                    class="lable-input-group__label file-label-input-group__label"
                  >
                    <span
                      v-if="selfie.image"
                      class="icon-check-circle file-label-input-group__icon file-label-input-group__icon-active"
                    ></span>
                    <span
                      v-else
                      class="icon-close-circle file-label-input-group__icon"
                    ></span>
                    عکس سلفی
                  </div>
                  <utilities-file-input
                    v-model="selfie.image"
                    class="lable-input-group__input"
                    placeholder="انتخاب نشده"
                    accept="image/jpeg,jpg,png"
                    :error="errors.image"
                    v-bind="field"
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
        <app-account-attention-notes :items="attentionItems" title="نکات مهم احرازهویت" />
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
        label: 'ویدئو سلفی',
        value: 1,
      },
      radioItems: [
        {
          label: 'ویدئو سلفی',
          value: 1,
        },
        {
          label: 'عکس سلفی',
          value: 2,
        },
      ],
      step: 1,
      selfieSchema: {
        video: 'require',
        image: 'require',
      },
      selfie: {
        video: undefined,
        image: undefined,
      },
      attentionItems: [
        {
          text: 'در هنگام وارد کردن نام و نام خانوادگی به تمام موارد مانند همزه، تشدید ،آ ،ا ، فاصله بین نام و نام خانوادگی های دو قسمتی ، پسوند و پیشوند های نام و نام خانوادگی و غیره دقت نمایید همه چیز باید مطابق مدارک هویتی باشد .',
        },
        {
          text: 'test2',
        },
        {
          text: 'test3',
        },
        {
          text: 'test4',
        },
      ],
    }
  },
  watch: {
    selectedFileType() {
      this.selfie = {
        video: undefined,
        image: undefined,
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
