package main

import "fmt"

func main() {
	day := 6
	switch day {
	case 1:
		fmt.Println("Saturday")
	case 2:
		fmt.Println("sunday")
	case 3:
		fmt.Println("monday")
	case 4:
		fmt.Println("Thursday")
	case 5:
		fmt.Println("Wednesday")
	case 6:
		fmt.Println("Tuesday")
	case 7:
		fmt.Println("friday")
	default:
		fmt.Println("Invalid Day")
	}
}
