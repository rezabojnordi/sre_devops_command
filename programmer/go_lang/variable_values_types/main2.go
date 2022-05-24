package main

import "fmt"
type float float64

func main() {
	var f float = 52.25
	var g float64 = 52.25
	fmt.Printf("f has value %v and type %T", f,f)
	//fmt.Println("f == g", f == g) // it doesn't work
	//fmt.Println("f == g", f == float(g)) // it work
}