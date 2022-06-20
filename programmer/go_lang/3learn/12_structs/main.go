package main

import "fmt"

// OOP

type Trade struct {
	// if property name starts with capital letter, that's public otherwise is private:
	Symbol string  // Stock symbol
	Volume int     // Number of shares
	Price  float64 // Trade Price
	Buy    bool    // true if buy trade, false if sell trade
}

func main() {
	t1 := Trade{"APPLE", 10, 99.98, true}
	fmt.Println(t1)
	fmt.Printf("%+v\n", t1)
	fmt.Println(t1.Symbol)

	t2 := Trade{
		Volume: 15,
		Symbol: "MICROSOFT",
		Price:  99.97,
		Buy:    false, // trailing comma is mandatory
	}
	fmt.Println(t2)
	fmt.Printf("%+v\n", t2)

	t3 := Trade{}
	fmt.Println(t3)
	fmt.Printf("%+v\n", t3)
}
