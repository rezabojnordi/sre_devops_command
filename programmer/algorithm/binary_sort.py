def binary_sort(list,item):
    
    low = 0
    high = len(list) -1
    list = sorted(list)

    while low <= high:
        mid = (low + high) // 2
        guess = list[mid]
        if guess == item:
            return mid
        if guess > item:
            high = mid - 1
        else:
            low = mid + 1
    return None
my_list = [1,3,5,8,9]
print(binary_sort(my_list,3))
