package main

import (
	"fmt"
)

func main() {
	// arr := [3]int{1, 2, 3}
	// slice := arr[:]
	// arr[1] = 42
	// slice[2] = 27
	// fmt.Println(arr,slice)

	slice :=[]int{1, 2, 3}
	fmt.Println(slice)
	slice = append(slice,4,42,27)
	fmt.Println(slice)

	s2 := slice[1:]
	s3 := slice[:2]
	s4 := slice[1:2]
	fmt.Println(s2,s3,s4)

}