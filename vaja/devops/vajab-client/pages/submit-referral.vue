<template>
  <div class="submit-referral">
    <div class="submit-referral__inner">
      <img
        src="@/assets/images/logo.svg"
        alt="vajab logo"
        class="submit-referral__logo"
      />
      <div class="submit-referral__welcome">
        ورود شما را به وجب خوش آمد میگوییم : )
      </div>
      <div class="submit-referral__des">
        در صورت داشتن کد معرف، آن را در کادر زیر وارد کنید.
      </div>
      <g-input
        label="کد معرف"
        icon="icon-smileys"
        maxlength="100"
        type="tel"
        class="submit-referral__input"
      >
        <template #appended>
          <g-btn>تایید</g-btn>
        </template>
      </g-input>
      <router-link to="/">
        <g-btn class="mt-4">ورود به سایت</g-btn>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SubmitReferral',
}
</script>

<style lang="scss">
.submit-referral {
  background: linear-gradient(0deg, rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2)),
    radial-gradient(
      70.99% 84.22% at 80.89% 12.01%,
      #417887 0%,
      #134452 50.56%,
      #0d191d 100%
    );
  min-height: 100vh;
  display: flex;
  text-align: center;
  &__logo {
    width: 100%;
    max-width: 18.18rem;
    margin: 0 auto;
    margin-bottom: 3rem;
  }
  &__welcome {
    color: white;
    font-size: 1.5rem;
    font-weight: bold;
  }
  &__des {
    font-size: 0.9rem;
    margin-top: 0.5rem;
    margin-bottom: 1.8rem;
    color: #e6e6e6;
    font-weight: 300;
  }
  &__inner {
    width: 100%;
    max-width: 602px;
    margin: auto;
    padding: 1rem;
  }
  &__input {
    .global-input__inner {
      background-color: #2d5d6a;
      border-color: #2d5d6a;
      color: white;
    }
    .global-input__label {
      color: inherit;
    }
    .global-input__icon {
      color: inherit;
    }
    input {
      color: inherit;
    }
    button {
      font-size: 0.8rem;
      font-weight: 400;
    }
  }
}
</style>
