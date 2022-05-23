package main

import "fmt"

//Package scope array definition
var integerArray [5]int

var stringArray [4]string

func main() {

	integerArray[0] = 10
	integerArray[1] = 20
	integerArray[2] = 30
	integerArray[3] = 40
	integerArray[4] = 50

	fmt.Println("This is the integer Array: ", integerArray)

	stringArray[0] = "first"
	stringArray[1] = "second"
	stringArray[2] = "third"
	stringArray[3] = "fourth"

	fmt.Println("This is the string array: ", stringArray)

	integerArray := [5]int{10, 20, 30, 40, 50}
	stringArray := [4]string{"first", "second", "third", "fourth"}

	fmt.Println("This is the integer array: ", integerArray)
	fmt.Println("This is the string array: ", stringArray)

}
