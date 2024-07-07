import HttpFactory from '~/repository/factory'
import { ListBankcardResponseInterface } from '~/types/account/bankcard.interface'

class AccountModule extends HttpFactory {
  private RESOURCE = '/bankcard'

  async list(): Promise<ListBankcardResponseInterface> {
    return await this.call<ListBankcardResponseInterface>(
      'GET',
      `${this.RESOURCE}`
    )
  }
}
export default AccountModule
