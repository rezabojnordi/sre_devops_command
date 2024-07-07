// https://nuxt.com/docs/api/configuration/nuxt-config
import fa from './locale/fa.js'
import en from './locale/en.js'

export default defineNuxtConfig({
  components: [
    { path: '~/components/global', pathPrefix: false },
    '~/components',
  ],
  imports: {
    dirs: ['composables'],
  },
  runtimeConfig: {
    API_URL: process.env.API_URL,
    WEBSITE_URL: process.env.WEBSITE_URL,
    PORT: process.env.PORT,
  },
  css: [
    '@/assets/styles/components.scss',
    '@/assets/styles/fontiran.css',
    '@/assets/styles/style.css',
    '@/assets/styles/texts.scss',
    '@/assets/styles/vars.css',
    '@/assets/styles/setting.scss',
    '@/assets/styles/spacing.css',
    '@/assets/styles/grid.scss',
  ],
  vite: {
    resolve: {
      mainFields: ['browser', 'module', 'main', 'jsnext:main', 'jsnext'],
      alias: [
        {
          find: '@vue/runtime-core',
          replacement: '@vue/runtime-core/dist/runtime-core.esm-bundler.js',
        },
      ],
    },
    server: {
      hmr: {
        protocol: 'ws',
        host: 'localhost',
      },
      watch: {
        usePolling: true,
        interval: 5,
      },
    },
    css: {
      preprocessorOptions: {
        scss: {
          additionalData:
            '@use "sass:math"; @import "@/assets/styles/variables.scss";',
        },
      },
    },
  },
  modules: [
    '@pinia/nuxt',
    '@nuxtjs/i18n',
    'vite-plugin-vue-type-imports/nuxt',
    '@vueuse/nuxt',
  ],
  i18n: {
    locales: [
      {
        name: 'farsi',
        code: 'fa',
      },
      {
        name: 'english',
        code: 'en',
      },
    ],
    defaultLocale: 'fa',
    vueI18n: {
      messages: {
        fa: fa,
        en: en,
      },
      fallbackWarn: false,
      missingWarn: false,
      silentTranslationWarn: true,
    },
  },
  plugins: [
    { src: '~/plugins/set-cookies' },
    { src: '~/plugins/prototypes' },
    { src: '~/plugins/global-components' },
    { src: '~/plugins/date-picker', mode: 'client' },
    { src: '~/plugins/breakpoint', mode: 'client' },
  ],
  app: {
    pageTransition: {
      name: 'fade',
      mode: 'out-in', // default
    },
    head: {
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1',
      title: 'وجب',
      meta: [
        {
          name: 'description',
          content: 'خرید و فروش ارزدیجیتال و انواع خدمات با وجب',
        },
        { name: 'format-detection', content: 'telephone=no' },
      ],
      link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
    },
  },
})
