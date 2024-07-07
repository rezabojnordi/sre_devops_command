def find_bigest(arr):
    bigest = arr[0]
    bigest_index = 0
    for i in range(1,len(arr)):
        if arr[i] > bigest:
            bigest = arr[i]
            bigest_index = i
    return bigest_index

my_list = [1,4,5,44,34,2,1000]
print(find_bigest(my_list))