// ssr plugins
// validation global rules

import { defineRule } from 'vee-validate'
import { setLocale } from 'yup'

export default defineNuxtPlugin(() => {
  defineRule('required', (value: string) => {
    if (!value || !value.length) {
      return 'این فیلد اجباری است'
    }
    return true
  })

  defineRule('email', (value: string) => {
    const message = 'لطفا ایمیل صحیح وارد کنید'
    if (!value || !value.length) {
      return message
    }
    // Check if email
    if (!/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(value)) {
      return message
    }
    return true
  })

  defineRule('phone', (value: string) => {
    // Field is empty, should pass
    const message = 'لطفا شماره تلفن صحیح وارد کنید'
    if (!value || !value.length) {
      return message
    }
    // Check if phone
    if (!/09[0-9]{9}$/.test(value)) {
      return message
    }
    return true
  })

  // defineRule('minMax', (value: string, [min, max]) => {
  //     // The field is empty so it should pass
  //     if (!value || !value.length) {
  //         return true;
  //     }
  //     const numericValue = Number(value);
  //     if (numericValue < min) {
  //         return `تعداد کاراکتر ها باید حداقل ${min} باشد`;
  //     }
  //     if (numericValue > max) {
  //         return `تعداد کاراکتر ها باید حداکثر ${max} باشد`;
  //     }
  //     return true;
  // });

  setLocale({
    mixed: {
      default: 'forms.validation.error.default',
      required: 'forms.validation.error.required',
    },
    number: {
      min: ({ min }) => ({ key: 'field_too_short', values: { min } }),
    },
  })
})
