<template>
  <div>
    <div class="main-inner-container download-section-outer">
      <div class="download-section">
        <div class="download-section__context">
          <div class="download-section__qr-code">
            <g-qrcode
              value="https://play.google.com/store/apps/details?id=com.binance.dev&hl=en&gl=US"
            />
          </div>
          <div class="download-section__content">
            <div class="mb-2 text-title-3">اپلیکیشن وجب</div>
            <div class="text-regular-4 text-justify">
              شما می توانید با نصب اپلیکیشن وجب ؛ در هر جا و هر زمان دسترسی به
              پنل خود داشته و معاملات خود را کنترل نمایید . در صورت نیاز به
              راهنمایی از بخش چت آنلاین در اپلیکیشن با ما در ارتباط باشید
            </div>
          </div>
          <g-row class="download-section__market" :gutter="10">
            <g-col :xs="8">
              <img
                src="~/assets/images/main-page/cafe-bazaar-download.png"
                alt="sibapp downlad"
              />
            </g-col>
            <g-col :xs="8">
              <img
                src="~/assets/images/main-page/google-play-download.png"
                alt="sibapp downlad"
              />
            </g-col>
            <g-col :xs="8">
              <img
                src="~/assets/images/main-page/sibapp-download.png"
                alt="sibapp downlad"
              />
            </g-col>
          </g-row>
        </div>
        <img
          src="~/assets/images/main-page/phones.png"
          alt="phones"
          class="download-section__phones"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped>
.download-section-outer {
  padding-top: 4rem;
}
.download-section {
  position: relative;
  padding: 53px 73px;
  &::before {
    content: ' ';
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    border-radius: 50px;
    background: linear-gradient(261.17deg, #083843 32.76%, #0a7088, #0a758e);
    transform: rotate(-180deg);
    z-index: -1;
  }
  &__phones {
    position: absolute;
    width: 47%;
    height: auto;
    bottom: 10px;
    left: 0;
  }
  &__context {
    width: 53%;
    color: white;
    display: flex;
    flex-wrap: wrap;
  }
  &__qr-code {
    width: 130px;
    height: 130px;
    background-color: $--color-white;
    border-radius: $--border-radius-base;
    padding: 0.9rem;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 3rem;
  }
  &__content {
    flex: 1;
    margin: 0 1.7rem;
  }
  &__market {
    flex: 0 0 100%;
    max-width: 494px;
    img {
      width: 100%;
    }
  }
}
</style>
