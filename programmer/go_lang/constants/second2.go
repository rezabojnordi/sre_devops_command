package main

import (
	"fmt"
)

// this code is good at
// func main(){
// 	const c  = 3
// 	fmt.Println(c + 3)

// 	// a bunch of code 
// 	fmt.Println(c + 1.2)
// }

//=================================This code is bad at===============================
// func main() {
// 	const c int = 3
// 	fmt.Println(c +3)
// 	// a bunch of code 
// 	fmt.Println(c + 1.23)
// }

// This code is good at
func main() {
	const c int = 3
	fmt.Println(c +3)
	// a bunch of code 
	fmt.Println(float32(c) + 1.23)
}