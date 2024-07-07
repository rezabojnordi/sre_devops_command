package main

import (
	"fmt"
	"os"
)

// OOP

type Trade struct {
	Symbol string  // Stock symbol
	Volume int     // Number of shares
	Price  float64 // Trade Price
	Buy    bool    // true if buy trade, false if sell trade
}

// NewTrade Constructor
func NewTrade(symbol string, volume int, price float64, buy bool) (*Trade, error) {
	if symbol == "" {
		return nil, fmt.Errorf("symbol can't be empty")
	}

	if volume <= 0 {
		return nil, fmt.Errorf("volume must be >= 0 (was %d)", volume)
	}

	if price <= 0.0 {
		return nil, fmt.Errorf("price must be >= 0 (was %f)", price)
	}

	trade := &Trade{
		Symbol: symbol,
		Volume: volume,
		Price:  price,
		Buy:    buy,
	}

	return trade, nil
}

func (trade *Trade) Value() float64 {
	value := float64(trade.Volume) * trade.Price
	if trade.Buy {
		value = -value
	}

	return value
}

func main() {
	t, err := NewTrade("MICROSOFT", 10, 100.00, true)

	if err != nil {
		fmt.Printf("ERROR: can't create trade - %s\n", err)
		os.Exit(1)
	}

	fmt.Println(t.Value())
}
