export default defineNuxtPlugin((NuxtApp) => {
  const windowWidth = ref(window.innerWidth)

  const onWidthChange = () => (windowWidth.value = window.innerWidth)
  window.addEventListener('resize', onWidthChange)

  NuxtApp.vueApp.config.globalProperties.$isSm = computed(() => {
    return windowWidth.value <= 768
  })
})
