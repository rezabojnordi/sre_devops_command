<template>
  <div>
    <div class="main-inner-container">
      <g-row :gutter="72">
        <g-col flex-1>
          <h3 class="my-0 text-title-3">{{ title }}</h3>
          <p class="text-regular-4 text-light text-justify">
            {{ description }}
          </p>
        </g-col>
        <g-col>
          <div class="about-video">
            <iframe
              data-v-22167e4c=""
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowfullscreen="allowfullscreen"
              class="order-1 md:order-4 rounded-xl lg:mt-12 lazyLoad isLoaded"
              style="width: 100%; min-height: 356px"
              src="https://www.aparat.com/video/video/embed/videohash/rJai1/vt/frame?recom=none"
            ></iframe>
          </div>
        </g-col>
      </g-row>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: '',
      require: true,
    },
    description: {
      type: String,
      default: '',
      require: true,
    },
  },
}
</script>

<style lang="scss" scoped>
.about-video {
  width: 520px;
  height: 276px;
  border-radius: 20px;
  overflow: hidden;
}
</style>
