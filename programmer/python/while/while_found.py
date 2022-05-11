l = [1,2,3]
val = 10

found = False

idx = 0

while idx < len(l):
    if l [idx] == val:
        found = True
        break
    idx += 1
if not found:
    l.append(val)
print(l)
