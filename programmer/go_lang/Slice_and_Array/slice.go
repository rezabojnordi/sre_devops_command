package main

import "fmt"

// Unlike an array, no need to specify the lenght of the slice when definiting it.

// var s []int

// s := []int{1, 2, 3, 4}

// Because slice is pointer type, weh should need first

// Package sope array definition
var integerSlice []int
var stringSlice []string

func main() {
	integerSlice = []int{1, 2, 3, 4}
	fmt.Println("integerSlice:", integerSlice)
	integerSlice[0] = 10
	integerSlice[1] = 20
	integerSlice[2] = 30
	integerSlice[3] = 40
	fmt.Println("integerArray:==>", integerSlice)
	stringSlice = []string{"first", "second", "third"}
	fmt.Println("stringArray:==>", stringSlice)

	printIngest()
	s := []int{1, 2, 3, 4}
	fmt.Println("len(s) :", len(s), "cap(s)", cap(s)) // slice is deffrent size capasity use for slice
	fmt.Println(s[0:2])
	fmt.Println(s[0:])

	// C R U D
	//s = []int{1, 2, 3, 4}
	// ADD
	//s = append(s,50)
	//s = append(s,60,70)

	// Update
	// a[i] = a[len(a) -1]

	// Read
	// a = a[j:n]

	// delete
	//a = append(a[:i], a[i+1]...)  / included, but

}

func printIngest() {
	fmt.Println("print the integers", integerSlice)
}
