package main

import (
	"fmt"
)

func main() {
	checkDayOfWeek(3)
}

func checkDayOfWeek(day int) {
	if day == 1 {
		fmt.Println("Saturday")
	}
	if day == 2 {
		fmt.Println("sunday")
	}
	if day == 3 {
		fmt.Println("monday")
	}
	if day == 4 {
		fmt.Println("Thursday")
	}
	if day == 5 {
		fmt.Println("Wednesday")
	}
	if day == 6 {
		fmt.Println("Tuesday")
	}
	if day == 7 {
		fmt.Println("friday")
	}

}
