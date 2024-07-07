<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="true"
      :tabs="tabs"
      @openHelp="helpPopup = true"
    >
      <app-account-security v-if="selectedTab.value === 1" />
      <app-account-security-history v-else-if="selectedTab.value === 2" />
    </AppAccountCard>
    <utilities-side-popup v-model="helpPopup">
      <span> ببعی میگه به به </span>
    </utilities-side-popup>
  </div>
</template>

<script setup lang="ts">
const path = ref({
  parent: 'حساب کاربری',
  child: 'امنیت',
})
const selectedTab = ref({
  text: 'امنیت حساب',
  value: 1,
})
const tabs = ref([
  {
    text: 'امنیت حساب',
    value: 1,
  },
  {
    text: 'تاریخچه فعالیت',
    value: 2,
  },
])
const helpPopup = ref(false)
</script>

<style lang="scss" scoped></style>
