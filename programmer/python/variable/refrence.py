import sys
import ctypes
a = [1,2,3,4]

print(id(a))

print(sys.getrefcount(a))

def ref_count(address: int):
    return ctypes.c_long.from_address(address).value

print(ref_count(id(a)))

b = a

print(ref_count(id(b)))


