package main

import (
	"fmt"
)

func main() {

	//var cart string = "Hi reza"
	//cart := "ACE of Spades"
	cart := new_cart()
	//cart = "Hi Reza"
	fmt.Println(cart)
}

func new_cart() string {
	return "five of Diamonds"
}
