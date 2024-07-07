package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("hello world!")
	sum := 0

	for i := 0; i < 10; i++ {
		sum += i
	}

	fmt.Println("sum", sum)
	//-------------------looo replice while----------------------------------------------------------------
	n := 1
	for n < 5 {
		n *= 2

	}
	fmt.Println("n:", n)
	//----------------------infinitive code------------------------------------------
	count := 0
	for {
		fmt.Println("Infinitive loop.....")
		count++
		time.Sleep(1 * time.Second)
		if count%2 != 0 {
			break
			//continue
		}
	}

}
