min_length = 2
name = input("please enter your name:")

# while not(len(name) >= min_length and name.isprintable() and name.isalpha()):
#     name = input("please enter your name:")

# print("HELLO, {0}".format(name))

while True:
    name = input("please enter ypur name:")
    if len(name) >= min_length and name.isprintable() and name.isalpha():
        break
print("HELLO, {0}".format(name))
