import re
# a = ""
# with open("1.txt", 'r') as f:
#     for line in f:
#         print(line)
#         x = re.search(r"\bS\w+", line)

f = open("1.txt", "r")
r = f.read()
x = x = re.findall("/var/lib/nova/instances", r)
print(x)
