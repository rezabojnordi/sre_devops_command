export function useAssetMedia(path: string): string {
  const glob = import.meta.glob(
    '~/assets/**/*.(svg|png|webp|jpg|jpeg|jfif|pjpeg|pjp|gif)',
    {
      eager: true,
      import: 'default',
    }
  )

  // const images = Object.fromEntries(
  //   Object.entries(glob).map(([key, value]) => [filename(key), value.default])
  // )

  const img = glob[path]
  if (!img) {
    const notFoundImage = '/assets/images/ops.svg'
    // @ts-expect-error: wrong type info
    return glob[notFoundImage]
  }
  // @ts-expect-error: wrong type info
  return glob[path]
}
