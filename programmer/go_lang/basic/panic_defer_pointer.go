package main

import "fmt"

func main() {
	//var pI *int // memory Address Of Int
	//var I int = 3

	//pI = &I
	//fmt.Println(pI)

	// inc(I)
	// fmt.Println(I)
	//fmt.Println(*pI)

	//testDefer()

	fmt.Println("hello")
	testPanic()
	fmt.Println("hello")
}

// func inc(p int) {
// 	p++
// }

// func inc(p *int) {
// 	*p++
// }

// func testDefer() {
// 	defer fmt.Println("world1")
// 	defer fmt.Println("world2")
// 	fmt.Println("hello")
// }

func testPanic() {
	defer func() {
		if err := recover(); err != nil {
			fmt.Println("panic handeled : ")
			fmt.Println(err)
		}
	}()
	panic(" hahahaha i am panic!!!")
}
