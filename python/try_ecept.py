a= 10
b = 1

try:
    a/b
except ZeroDivisionError:
    print('division by e')
finally:
    print("this always executes")
    