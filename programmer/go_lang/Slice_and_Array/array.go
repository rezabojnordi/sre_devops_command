package main

import "fmt"

// Array: Store fixed number of elements

// var my_array [size]type
// var integer_array [5]int

// a:= [5]int{1020,30,40,50,60}
//b := [4]string{"a", "b", ""}

var integerArray [5]int
var stringArray [4]string

func main() {
	integerArray[0] = 10
	integerArray[1] = 20
	integerArray[2] = 30
	integerArray[3] = 40
	integerArray[4] = 50
	fmt.Println(integerArray)

	stringArray[0] = "first"
	stringArray[1] = "second"
	stringArray[2] = "third"
	stringArray[3] = "fourth"
	fmt.Println(stringArray)
}
