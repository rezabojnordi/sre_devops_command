package main

import "fmt"

const pi = 3.1415
func main() {
	fmt.Println(pi)
	main2()
}

const (
	first = iota + 6
	// second = 2 << iota  // out 4
	 second // out 7
)

const (
	third = iota
	fourth
)

func main2() {
	fmt.Println(first,second,third,fourth)
}