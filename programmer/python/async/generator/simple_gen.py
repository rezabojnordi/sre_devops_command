from typing import List

# def fib(n: int) -> List[int]:
#     numbers = []
#     current, nxt = 0,1
#     while len(numbers) < n:
#         current, nxt = nxt, current + nxt
#         numbers.append(current)

#     return numbers



def fib():
    current, nxt = 0,1
    while True:
        current, nxt = nxt, current + nxt
        yield current


for n in fib():
    print(n, end=', ')
    if n > 10000:
        break
print("Done")

