
from concurrent.futures import thread
import datetime
import math
from threading  import Thread
import time
import multiprocessing

class Account:
    def __init__(self,balance=0):
        self.balance = balance



def main():
    account = create_accounts()

    total = sum(a.balance for a in account)
    validate_balance(account,total)

    jobs = [
        Thread(target=do_bank_stuff, args=(account,total)),
        Thread(target=do_bank_stuff, args=(account,total)),
        Thread(target=do_bank_stuff, args=(account,total)),
        Thread(target=do_bank_stuff, args=(account,total)),
        Thread(target=do_bank_stuff, args=(account,total))
    ]

    t0 = datetime.datetime.now()
    [j.start() for j in jobs]
    [j.join() for j in jobs]
    dt = datetime.datetime.now() -t0
    print("Transfers complete ({:,.2f} sec".format(dt.total_seconds()))

def do_bank_stuff(account,total):
    for _ in range(1,10_000):
        a1,a2 = get_two_accounts(accounts)
        amount = random.randint(1,1000)
        do_transfer(a1,a2,account)
        validate_bank(account,total,quite=True)

def create_accounts() -> List[Account]:
    return [
        Account(balance=5000),
        Account(balance=10000),
        Account(balance=7500),
        Account(balance=7000),
        Account(balance=6000),
        Account(balance=9000)]

def do_transfer(from_account: Account, to_account: Account, amount: int):
    if from_account.balance < amount:
        return

    from_account.balance -=amount
    time.sleep(.000)
    to_account.balance +=amount

def validate_balance(account: List[Account], total: int,quite=False):
    current = sum(a.balance for a in account)
    if current != total:
        print("Error: Inconsistent account balance ${:,} vs ${:,}".format(current, total),flush=True)
    elif not quite:
        print("All good: Consistent account balance: ${:,}".format(total),flush=True)
