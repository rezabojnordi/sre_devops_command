package main

import (
	"fmt"
	"sync"
)

func say(s string, wg *sync.WaitGroup) {
	for i := 1; i < 5; i++ {
		//time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
	wg.Done()
}

func main() {
	var wg sync.WaitGroup
	wg.Add(1)
	go say("world", &wg)
	wg.Wait()
	//wait
	wg.Add(1)
	say("hello world", &wg)
	wg.Wait()
	fmt.Println("finished")
}
