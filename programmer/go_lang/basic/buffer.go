package main

import (
"fmt"
"time"
)

func main() {
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	fmt.Println(<-ch)
	fmt.Println(<-ch)
	time.Sleep(3*time.Second)
	ch <- 3
	fmt.Println(<-ch)
}
