import { easyReadNumber, faNumToEn } from '~/composables/useString'
import { formatBankcard } from '~/composables/useBankcards'

export class InputStrategy {
  private strategy: Strategy
  constructor(strategy: Strategy) {
    this.strategy = strategy
  }
  public setStrategy(strategy: Strategy) {
    this.strategy = strategy
  }
  public get(model: any): string {
    return this.strategy.get(model)
  }
  public set(val: any): any {
    return this.strategy.set(val)
  }
}

export interface Strategy {
  get(model: any): string
  set(val: any): any
}

export class TextStrategy implements Strategy {
  public get(model: any): string {
    return model
  }

  public set(val: any): any {
    return val
  }
}

export class NumberStrategy implements Strategy {
  public get(model: any): string {
    return easyReadNumber(model.toString() || '', 6).show
  }

  public set(val: any): any {
    return typeof val === 'string'
      ? Number(faNumToEn(val).replaceAll(',', ''))
      : val
  }
}

export class BankcardStrategy<T> implements Strategy {
  public get(model: any): string {
    return formatBankcard(model.toString() || '')
  }

  public set(val: any): any {
    return typeof val === 'string' ? faNumToEn(val).replaceAll('-', '') : val
  }
}
