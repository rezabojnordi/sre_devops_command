a = 0
b = 2

while a < 4:
    print('--------------')
    a +=1
    b -=1

    try:
        a/b
    except ZeroDivisionError:
        print("{0},{1} - always executes".format(a,b))
        continue
    finally:
        print("{0},{1} - main loop".format(a,b))
    print("{0},{1} - main loop".format(a,b))
