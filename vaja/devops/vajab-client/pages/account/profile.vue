<template>
  <div>
    <AppAccountCard
      v-model:selected="selectedTab"
      icon="icon-user-edit"
      :path="path"
      :has-help="true"
      :tabs="tabs"
      class="profile-account-card"
      @openHelp="helpPopup = true"
    >
      <g-row :gutter="30">
        <g-col :xs="8">
          <g-input
            v-model="userInfo.name"
            label="نام و نام خانوادگی"
            icon="icon-user-edit"
            type="text"
            readonly
          />
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.natCode"
            label="کدملی"
            icon="icon-personalcard"
            type="text"
            readonly
          />
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.email"
            label="ایمیل"
            icon="icon-sms-tracking"
            type="text"
            readonly
          >
            <template #appended>
              <span
                class="input-edit-icon icon-edit-2"
                @click="changeEmailPopup = true"
              ></span>
            </template>
          </g-input>
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.birthDate"
            label="تاریخ تولد"
            icon="icon-calendar-half"
            type="text"
            readonly
          />
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.mobile"
            label="شماره همراه"
            icon="icon-mobile"
            type="text"
            readonly
          >
            <template #appended>
              <span class="input-success-icon icon-check-circle"></span>
            </template>
          </g-input>
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.postCode"
            label="کدپستی"
            icon="icon-sms"
            type="text"
            readonly
          >
            <template #appended>
              <span class="input-edit-icon icon-edit-2"></span>
            </template>
          </g-input>
        </g-col>
        <g-col :xs="8">
          <g-input
            v-model="userInfo.phone"
            label="شماره ثابت"
            icon="icon-call"
            type="text"
            readonly
          >
            <template #appended>
              <span class="input-edit-icon icon-edit-2"></span>
            </template>
          </g-input>
        </g-col>
        <g-col :xs="16">
          <g-input
            v-model="userInfo.address"
            label="آدرس"
            icon="icon-map"
            type="text"
            readonly
          >
            <template #appended>
              <span class="input-edit-icon icon-edit-2"></span>
            </template>
          </g-input>
        </g-col>
      </g-row>
    </AppAccountCard>
    <app-account-profile-change-email v-model="changeEmailPopup" />
  </div>
</template>

<script lang="ts">
export default {
  data() {
    return {
      changeEmailPopup: false,
      path: {
        parent: 'حساب کاربری',
        child: 'اطلاعات کاربری',
      },
      selectedTab: {
        text: 'اطلاعات کاربری',
        value: 1,
      },
      tabs: [
        {
          text: 'اطلاعات کاربری',
          value: 1,
        },
      ],
      helpPopup: false,
      userInfo: {
        name: 'امیرحسن چناری شاندیز',
        natCode: '0925243659',
        email: 'امیرحسن چناری شاندیز',
        birthDate: '2000/1/1',
        mobile: '09375698569',
        postCode: '1234567891',
        phone: '05134256954',
        address: 'مشهد، بلوار کلاهدوز، کلاهدوز ۲۷، تورج ۲۱، پلاک ۹۴',
      },
    }
  },
}
</script>

<style lang="scss" scoped>
.input-edit-icon {
  color: #c8c7c6;
  margin-right: 0.2rem;
  cursor: pointer;
}
.input-success-icon {
  color: $--color-success-300;
  margin-right: 0.2rem;
}
.profile-account-card {
  .account-card {
    // min-height: calc(100vh - 110px);
  }
}
</style>
