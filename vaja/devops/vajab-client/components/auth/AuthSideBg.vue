<template>
  <div>
    <div class="side-bg">
      <div>
        <img
          src="~/assets/images/auth-bg.png"
          alt="auth background"
          class="side-bg__bg"
        />
      </div>
      <router-link to="/">
        <img src="~/assets/images/logo.svg" alt="logo" class="side-bg__logo" />
      </router-link>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.side-bg {
  text-align: center;
  &__bg {
    margin-top: 2rem;
    width: auto;
    height: calc(100vh - 9.5rem);
    max-width: 100%;
    object-fit: contain;
  }
  &__logo {
    width: 7.5rem;
  }
}
</style>
