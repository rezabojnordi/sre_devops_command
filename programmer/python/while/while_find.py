l = [1,2,3,10]
val = 10
idx = 0
while idx < len(l):
    print("val:",val,"l[idx] :",l[idx] )
    if l[idx] == val:
        break
    idx += 1
else:
    l.append(val)

print(l)