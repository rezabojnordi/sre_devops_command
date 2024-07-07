const showBackground = ref<boolean>(false)
export function useBackground() {
  function toggle() {
    showBackground.value = !showBackground.value
  }

  return { showBackground: computed(() => showBackground.value), toggle }
}
