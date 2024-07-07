import { NoticeTypeEnum } from '~/constant/enum/notice.type.enum'

export interface NotificationInterface {
  id: number
  noticeType: NoticeTypeEnum
  title: string
  date: Date
  content: string
  isRead: boolean
}
