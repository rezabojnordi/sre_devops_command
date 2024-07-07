package main

import "fmt"

func main() {
	cards := []string{"Ace diamon", new_cart()}
	cards = append(cards, "six of Spades")

	// for i, card := range cards {

	// 	fmt.Println(i, card)
	// }
	var i int = 0
	for i = 0; i < len(cards); i++ {
		fmt.Println(cards[i])

	}
}

func new_cart() string {
	return "five of Diamonds"
}
