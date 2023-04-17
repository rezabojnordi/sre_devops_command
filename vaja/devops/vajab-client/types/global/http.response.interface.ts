export interface HttpResponseInterface<T> {
  statusCode: number
  message: string
  data?: T
}
