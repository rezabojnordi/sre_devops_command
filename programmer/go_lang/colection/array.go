package main

import (
	"fmt"
)

func main() {
	var arr [3]int
	arr[0] = 1
	arr[1] = 2
	arr[2] = 3
	fmt.Println(arr)
	fmt.Println(arr[1])
	//fmt.Println(arr[4]) // array index 4 out of bounds [0:3] 

	arr2 := [3]int{1, 2, 3}
	fmt.Println(arr2)
}