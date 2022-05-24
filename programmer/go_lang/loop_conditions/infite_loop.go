package main

import "fmt"

func main() {
	sum := 0
	for {
		sum++
		if sum == 20 {
			break
		}
	}
	fmt.Println("sum:", sum)
}
