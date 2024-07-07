<template>
  <div>
    <div class="why-container main-inner-container">
      <div class="g-justify-space-between g-align-center g-row">
        <h3 class="text-title-3 my-0">چرا از وجب استفاده کنیم</h3>
        <div class="color-primary">
          <span class="mx-2 text-title-4">مشاهده سوالات متداول</span>
          <span class="icon-arrow-left vertical-middle"></span>
        </div>
      </div>
      <g-row :gutter="30" :y-gutter="30">
        <g-col :xs="10">
          <div class="why-card">
            <img
              src="~/assets/images/download/benefit-1.png"
              alt="fast authentication"
              class="why-card__img"
            />
            <div class="why-card__context">
              <h4 class="why-card__title">احراز هویت سریع</h4>
              <p class="why-card__des">
                در صرافی وجب، در کمتر از پنج دقیقه ثبت نام و معامله در پرسودترین
                بازارها را آغاز کنید.
              </p>
            </div>
          </div>
        </g-col>
        <g-col :xs="14">
          <div class="why-card">
            <img
              src="~/assets/images/download/benefit-2.png"
              alt="professional Possibilities"
              class="why-card__img"
            />
            <div class="why-card__context">
              <h4 class="why-card__title">امکانات پیشرفته برای معاملات</h4>
              <p class="why-card__des">
                ابزارهای مدرن برای انجام معاملات از جمله حد سود و ضرر، پنل گزارش
                سود و زیان، امکان تنظیم هشدار قیمت و همچنین نمودارهای قیمتی و
                ابزارهای تحلیل بازار در اختیار شماست.
              </p>
            </div>
          </div>
        </g-col>
        <g-col :xs="14">
          <div class="why-card">
            <img
              src="~/assets/images/download/benefit-3.png"
              alt="strong security"
              class="why-card__img"
            />
            <div class="why-card__context">
              <h4 class="why-card__title">سپرهای امنیتی مدرن</h4>
              <p class="why-card__des">
                تیم امنیتی پیشرفته وجب با ابزارهای مدرن و به‌روز، همواره برای
                حفظ امنیت دارایی کاربران تلاش می‌کنند. ذخیره امن دارایی کاربران
                در کیف پول‌های سرد و تایید هویت دو عاملی از جمله ...
              </p>
            </div>
          </div>
        </g-col>
        <g-col :xs="10">
          <div class="why-card">
            <img
              src="~/assets/images/download/benefit-4.png"
              alt="24h support"
              class="why-card__img"
            />
            <div class="why-card__context">
              <h4 class="why-card__title">پشتیبانی حرفه‌ای</h4>
              <p class="why-card__des">
                پشتیبانی حرفه‌ای و ۲۴ ساعته‌ی آنلاین و تلفنی وجب، خیال کاربران
                را برای پاسخ به هر سوالی آسوده می‌کند.
              </p>
            </div>
          </div>
        </g-col>
      </g-row>
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped>
.why-card {
  background-color: $--color-primary-50;
  border-radius: $--border-radius-base;
  min-height: 200px;
  display: flex;
  align-items: center;
  padding: 2rem 1.8rem;
  &__img {
    width: 100px;
    height: 100px;
  }
  &__context {
    flex: 1;
    margin-right: 1.6rem;
  }
  &__title {
    color: $--color-primary;
    margin-bottom: 0.3rem;
    font-weight: 700;
    font-size: 1.3rem;
    line-height: 42px;
    margin-top: 0;
  }
  &__des {
    margin: 0;
    font-weight: 400;
    font-size: 0.9rem;
    line-height: 28px;
    color: $--color-neutral-300;
  }
}
</style>
