package main

import (
	"fmt"
	"sync"
)

func sayHello(wg *sync.WaitGroup, PingChanel chan string, pongChanel chan string) {
	for i := 1; i < 100; i++ {
		fmt.Println("Hello")
		PingChanel <- "world!"
		<-pongChanel
	}
	wg.Done()
}

func sayWorld(wg *sync.WaitGroup, PingChanel chan string, pongChanel chan string) {
	for i := 1; i < 100; i++ {
		v := <-PingChanel
		fmt.Println(v)
		pongChanel <- "pong"
	}
	wg.Done()
}
func main() {
	var wg sync.WaitGroup
	PingChanel := make(chan string)
	pongChanel := make(chan string)
	wg.Add(1)
	go sayHello(&wg, PingChanel, pongChanel)
	//wait
	wg.Add(1)
	go sayWorld(&wg, PingChanel, pongChanel)
	wg.Wait()
	fmt.Println("finished")
}
