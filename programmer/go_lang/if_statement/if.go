package main

import "fmt"

func main() {
	var x = 120
	for i := 0; i < x; i++ {
		if (i%5) == 0 && i < 100 {
			fmt.Println("x", i)
		}
	}
}

// if x :=25; x%5 ==o {

// }
