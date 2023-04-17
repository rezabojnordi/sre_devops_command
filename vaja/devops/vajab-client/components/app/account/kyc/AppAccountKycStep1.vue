<template>
  <div>
    <g-row :gutter="30">
      <g-col :xs="12">
        <div class="kyc-info-card">
          <div class="kyc-info-card__head">
            <div class="kyc-info-card__title">
              گام اول : لطفا مشخصات خود را تکمیل نمایید
            </div>
          </div>
          <g-row :gutter="25">
            <g-col>
              <app-account-kyc-wizard-step :step="step" />
            </g-col>
            <g-col flex-1>
              <div class="kyc-info-card__body">
                <Form
                  v-slot="{ errors }"
                  :validation-schema="userInfoSchema"
                  @submit="submitUserInfo()"
                >
                  <Field v-slot="{ field }" name="firstName">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label">نام</div>
                      <g-input
                        v-model="userInfo.firstName"
                        filled
                        maxlength="100"
                        type="text"
                        name="firstName"
                        :readonly="step === 2"
                        :error="errors.firstName"
                        v-bind="field"
                        class="lable-input-group__input"
                      />
                    </div>
                  </Field>

                  <Field v-slot="{ field }" name="lastName">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label">نام خانوادگی</div>
                      <g-input
                        v-model="userInfo.lastName"
                        filled
                        maxlength="100"
                        type="text"
                        name="lastName"
                        :readonly="step === 2"
                        :error="errors.lastName"
                        v-bind="field"
                        class="lable-input-group__input"
                      />
                    </div>
                  </Field>

                  <Field v-slot="{ field }" name="natCode">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label">کدملی</div>
                      <g-input
                        v-model="userInfo.natCode"
                        filled
                        maxlength="10"
                        type="tel"
                        name="natCode"
                        :error="errors.natCode"
                        :readonly="step === 2"
                        v-bind="field"
                        class="lable-input-group__input"
                      />
                    </div>
                  </Field>

                  <Field v-slot="{ field }" name="birthDate">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label">تاریخ تولد</div>
                      <g-input
                        id="birth-date"
                        filled
                        maxlength="20"
                        type="text"
                        name="birthDate"
                        :error="errors.birthDate"
                        readonly
                        :model-value="
                          $filters.jalaliMoment(
                            userInfo.birthDate,
                            'jYYYY-jMM-jDD'
                          )
                        "
                        v-bind="field"
                        class="lable-input-group__input"
                      />
                    </div>
                  </Field>
                </Form>

                <Form
                  v-slot="{ errors }"
                  :validation-schema="cardNumberSchema"
                  @submit="submitCardNumber()"
                >
                  <div class="attention-outer">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label"></div>
                      <div
                        v-if="step === 2"
                        class="attention-text-warning text-center flex-1"
                      >
                        توجه : شماره کارت وارد شده باید به نام علیرضا ارجی باشد
                      </div>
                    </div>
                  </div>

                  <Field v-slot="{ field }" name="cardNumber">
                    <div class="lable-input-group">
                      <div class="lable-input-group__label">شماره کارت</div>
                      <g-input
                        v-model="userInfo.cardNumber"
                        filled
                        maxlength="19"
                        type="tel"
                        autocomplete="off"
                        :error="errors.cardNumber"
                        :readonly="step !== 2"
                        v-bind="field"
                        class="lable-input-group__input"
                      />
                    </div>
                  </Field>
                </Form>
              </div>
            </g-col>
          </g-row>
        </div>
        <g-btn
          class="mt-4 w-100"
          :loading="loading"
          @click="step === 1 ? submitUserInfo() : submitCardNumber()"
          >ثبت و ادامه</g-btn
        >
      </g-col>
      <g-col :xs="12">
        <app-account-attention-notes :items="attentionItems" title="نکات مهم احرازهویت" />
      </g-col>
    </g-row>
  </div>

  <date-picker
    v-model="userInfo.birthDate"
    element="birth-date"
    format="YYYY-MM-DD"
    color="#45A8C2"
    view="year"
    :min="
      new Date(new Date().setFullYear(new Date().getFullYear() - 100)).toJSON()
    "
    :max="
      new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toJSON()
    "
  />
</template>

<script lang="ts">
export default {
  data() {
    return {
      loading: false,
      step: 1,
      cardNumberSchema: {
        cardNumber: (value: string) => {
          return value?.length === 19
            ? true
            : 'لطفا شماره کارت صحیح و 16 رقمی وارد کنید'
        },
      },
      userInfoSchema: {
        firstName: 'require',
        lastName: 'require',
        birthDate: 'require',
        natCode: (value: string) => {
          return value?.length === 10
            ? true
            : 'لطفا کدملی صحیح 10 رقمی وارد کنید'
        },
      },
      userInfo: {
        firstName: '',
        lastName: '',
        birthDate: '',
        natCode: '',
        cardNumber: '',
      },
      attentionItems: [
        {
          text: 'توجه داشته باشید اطلاعات هویتی ثبت شده قابل تغییر یا ویرایش نیست.',
        },
        {
          text: 'در هنگام وارد کردن نام و نام خانوادگی به تمام موارد مانند همزه، تشدید ،آ ،ا ، فاصله بین نام و نام خانوادگی های دو قسمتی ، پسوند و پیشوند های نام و نام خانوادگی و غیره دقت نمایید همه چیز باید مطابق مدارک هویتی باشد .',
        },
        {
          text: 'کد ملی بدون خط تیره وارد شود',
        },
        {
          text: 'درصورت بروز هرگونه مشکل در انجام فرایند میتوانید از طریق پشتیبانی آنلاین وجب با کارشناسان در ارتباط باشید.',
        },
      ],
    }
  },
  methods: {
    submitUserInfo() {
      alert('okkkk')
    },
    submitCardNumber() {
      alert('cardNum!!')
    },
  },
}
</script>

<style lang="scss" scoped>
.error-box {
  background-color: $--color-danger-50;
  padding: 2rem 2.2rem 1.2rem 2.2rem;
  border-radius: 0.625rem;
  &__title {
    display: flex;
    align-items: center;
    color: $--color-neutral-900;
    font-weight: 600;
    margin-bottom: 1rem;
    span {
      margin: 0 0.7rem;
    }
  }
  &__item {
    font-size: 0.9rem;
    color: $--color-danger-300;
    line-height: 3rem;
  }
}

.attention-outer {
  min-height: 2rem;
  margin-bottom: 1.2rem;
}
</style>
