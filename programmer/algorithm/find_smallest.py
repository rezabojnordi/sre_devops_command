def find_smallest(arr):
    smallest = arr[0]
    print("1",smallest)
    smallest_index = 0
    for i in range(1,len(arr)):
        if arr[i] < smallest:
            print("2",arr[i])
            smallest = arr[i]
            smallest_index = i
    return smallest_index

my_list = [3,4,5,23,2]
print(find_smallest(my_list))