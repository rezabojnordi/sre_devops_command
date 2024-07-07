# from traceback import print_tb


# myDict = {"name": "John", "country": "Norway"}
# mySeparator = "TEST"

# x = mySeparator.join(myDict)

# print(x)
# print(mySeparator.join("433"))
# for x in range(5 -1 , -5, -1):
#   print(x) 


L = []
lines = int(input())
for i in range(lines):
    line = input().split()
    print("===",line)
    command = line[0]
    if command == 'append':
        L.append(int(line[1]))
    elif command == 'insert':
        L.insert(int(line[1]), int(line[2]))
    elif command == 'remove':
        L.remove(int(line[1]))
    elif command == 'print':
        print(L)
    elif command == 'sort':
        L.sort()
    elif command == 'pop':
        L.pop()
    elif command == 'reverse':
        L.reverse()
    elif command == 'count':
        L.count(int(line[1]))