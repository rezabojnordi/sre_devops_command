export interface FaqContentPropsInterface {
  content: Array<ExpandableFaqPropsInterface>
}
export interface ExpandableFaqPropsInterface {
  question: string
  answer: string
}

export interface CategoryFaqInterface {
  icon: string
  text: string
  content: Array<ExpandableFaqPropsInterface>
}
