package main

import (
	"fmt"
	"time"
)

func main() {

	sum := 0

	for {
		sum++
		if sum%2 != 0 {
			continue
		}
		fmt.Printf("%d Infinitive loop ...\n", sum)
		time.Sleep(1 * time.Second)
	}
	fmt.Println("sum", sum)
}
