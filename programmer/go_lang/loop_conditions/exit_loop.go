package main

import "fmt"

func main() {
	sum := 0

	for i := 1; i < 5; i++ {
		if i%2 != 0 { // skip odd number
			continue //
		}

		if i%2 != 1 {
			break
		}

		sum += i
	}
	fmt.Println(sum) // 6 (2+4)
}
