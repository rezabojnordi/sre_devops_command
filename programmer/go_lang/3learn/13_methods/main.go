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

func (trade *Trade) Value() float64 {
	value := float64(trade.Volume) * trade.Price
	if trade.Buy {
		value = -value
	}

	return value
}

func main() {
	t := Trade{"APPLE", 10, 99.98, true}
	fmt.Println(t.Value())
}
