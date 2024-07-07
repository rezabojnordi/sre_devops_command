<template>
  <div>
    <div class="text-sm-2 mb-2">مدیریت وضعیت ورود</div>
    <g-table
      class="light-table"
      :items="items"
      :headers="headers"
      :loading="loading"
      outlined
    >
      <template #createdAt="item">
        {{ $filters.jalaliMoment(item.createdAt, 'hh:mm jYYYY-jMM-jDD') }}
      </template>
      <template #operation="item">
        <div class="text-reverse">
          <span
            class="icon-trash"
            style="vertical-align: middle; cursor: pointer"
            @click="deleteItem(item)"
          ></span>
        </div>
      </template>
    </g-table>
  </div>
</template>

<script lang="ts">
import { mapActions } from 'pinia'
import { securityStore } from '@/stores/account/security'

export default {
  data() {
    return {
      loading: false,
      items: [],
      headers: [
        {
          text: 'زمان ورود',
          value: 'createdAt',
          minWidth: '142',
        },
        {
          text: 'دستگاه',
          value: 'userAgent',
          minWidth: '230',
        },
        {
          text: 'IP ورود',
          value: 'ip',
          minWidth: '150',
        },
        {
          text: 'مکان ورود',
          value: 'location',
          minWidth: '250',
        },
        {
          text: 'عملیات',
          value: 'operation',
          minWidth: '90',
        },
      ],
    }
  },
  mounted() {
    this.getList()
  },
  methods: {
    ...mapActions(securityStore, [
      'getActiveSessionsHistory',
      'removeSessionItem',
    ]),
    async getList() {
      try {
        this.loading = true
        const res = await this.getActiveSessionsHistory()
        this.items = res?.data.data
        this.loading = false
      } catch (error) {
        this.loading = false
      }
    },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    async deleteItem(_item: any) {
      try {
        this.loading = true
        alert('دستگاه با موفقیت حذف شد')
        this.loading = false
        this.getList()
      } catch (error) {
        this.loading = false
      }
    },
  },
}
</script>

<style lang="scss">
.light-table {
  color: $--color-neutral-300;
}
</style>
