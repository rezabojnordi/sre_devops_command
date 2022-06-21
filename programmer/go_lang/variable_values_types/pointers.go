package main

import (
	"fmt"
)

var a int =10

var p *int = &a // a addreess on memory
// The type *T is a pointer to a T value. Its zero value is nil.

// var p *int

//The& operator generates a pointer to its operand value
//i := 42
//p = &i
func main() {
	
	fmt.Println(a)
	fmt.Println(p)
	
	fmt.Println(&a)
	fmt.Println(*p)
}

func main2() {
	i,j := 42,2701
	p := &i  //point to i
	fmt.Println(*p) //read i through the pointer
	fmt.Println(p) //Print memory addreess
	*p = 21 // set i through the pointers
	fmt.Println(i) // see the new value of i

	p = &j // point to j

	*p = *p / 37 //divide j through the pointer

	fmt.Println(j) // see the new value of j

}