<template>
  <div id="tradingview-chart" />
</template>

<script lang="ts">
const SCRIPT_ID = 'tradingview-widget-script'

export default {
  props: {
    options: {},
    containerId: {
      type: String,
    },
    isMedium: {},
  },
  mounted() {
    this.appendScript(this.initWidget)
  },
  methods: {
    canUseDOM() {
      return (
        typeof window !== 'undefined' &&
        window.document &&
        window.document.createElement
      )
    },
    getScriptElement() {
      return document.getElementById(SCRIPT_ID)
    },
    updateOnloadListener(onload) {
      const script = this.getScriptElement()
      const oldOnload = script.onload
      return (script.onload = () => {
        oldOnload()
        onload()
      })
    },
    scriptExists() {
      return this.getScriptElement() !== null
    },
    appendScript(onload) {
      if (!this.canUseDOM()) {
        onload()
        return
      }

      if (this.scriptExists()) {
        if (typeof TradingView === 'undefined') {
          this.updateOnloadListener(onload)
          return
        }
        onload()
        return
      }
      const script = document.createElement('script')
      script.id = SCRIPT_ID
      script.type = 'text/javascript'
      script.async = true
      script.src = 'https://s3.tradingview.com/tv.js'
      script.onload = onload
      document.getElementsByTagName('head')[0].appendChild(script)
    },
    initWidget() {
      if (typeof TradingView === 'undefined') {
        return
      }
      new window.TradingView.widget(this.options)
    },
  },
}
</script>

<style lang="scss" media="screen">
#tradingview-chart {
  /* width: 100%; */
  position: relative;
  @media (max-width: 53.9em) {
    height: 22rem !important;
  }
}
</style>
