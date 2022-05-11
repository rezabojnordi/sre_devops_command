if __name__ == '__main__':
    arry=[]
    for _ in range(int(input())):
        name = input()
        score = float(input())
        arry.append([name,score])

second_highest = sorted(list(set([marks for name, marks in arry])))[1]
# print("second_highest:",second_highest)
print('\n'.join([a for a,b in sorted(arry) if b == second_highest]))