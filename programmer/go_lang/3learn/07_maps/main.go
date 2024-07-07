package main

import "fmt"

func main() {
	bar := map[string]float64{
		"AMAZON":    1700.0,
		"GOOGLE":    1130.0,
		"MICROSOFT": 100.5,
	}

	// Get a Value
	fmt.Println(bar["MICROSOFT"])

	// Get zero value if not found
	fmt.Println(bar["APPLE"]) // 0

	// Use two value to see if found
	value, ok := bar["APPLE"]

	if !ok {
		fmt.Println("APPLE not found")
	} else {
		fmt.Println(value)
	}

	// Set
	bar["APPLE"] = 350.0
	fmt.Println(bar)

	// Delete
	delete(bar, "AMAZON")
	fmt.Println(bar)

	// Single Value "for" is on keys
	for key := range bar {
		fmt.Println(key)
	}

	// Double Value "for" is key, value
	for key, value := range bar {
		fmt.Printf("%s - %.2f\n", key, value)
	}
}
