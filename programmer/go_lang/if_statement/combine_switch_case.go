package main

import "fmt"

func main() {
	switch day := 6; day {
	case 1, 2, 3, 4:
		fmt.Println("Weekday")
	case 6, 7:
		fmt.Println("Weekend")
	default:
		fmt.Println("Invalid Day")
	}
}
