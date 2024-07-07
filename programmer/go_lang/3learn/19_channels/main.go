package main

import (
	"fmt"
	"time"
)

// We have 2 kinds of channels: (Buffered, Unbuffered)
/* ====================================
BUFFERED CHANNEL EXAMPLE (capacity: 3)
=======================================
[ | | ] <- 1 NOT Blocked
[1| | ] <- 2 NOT Blocked
[1|2| ] <- 3 NOT Blocked
[1|2|3] <- 4 Blocked
======================================= */

func main() {
	channel := make(chan int)

	// This will block because nothing was pushed to the channel
	// <-ch
	// fmt.Println("Here")

	// Goroutine
	go func() {
		// Send number of the channel
		channel <- 25
	}()

	// Receive number from the channel
	val := <-channel
	fmt.Printf("got %d\n", val)
	fmt.Println("===============")

	// Send Multiple
	go func() {
		for i := 0; i < 3; i++ {
			fmt.Printf("sending %d\n", i)
			channel <- i
			time.Sleep(time.Second) // 1 second
		}
	}()

	// Receive multiple
	for i := 0; i < 3; i++ {
		val := <-channel
		fmt.Printf("received %d\n", val)
	}

	fmt.Println("===============")
	// close to signal we are done
	go func() {
		for i := 0; i < 3; i++ {
			fmt.Printf("sending %d\n", i)
			channel <- i
			time.Sleep(time.Second) // 1 second
		}
		close(channel)
	}()

	for i := range channel {
		fmt.Printf("received %d\n", i)
	}
}
