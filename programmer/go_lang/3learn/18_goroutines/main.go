package main

import (
	"fmt"
	"net/http"
	"sync"
)

func returnType(url string) {
	response, err := http.Get(url)
	if err != nil {
		fmt.Printf("ERROR: %s\n", err)
		return
	}

	defer response.Body.Close()
	contentType := response.Header.Get("Content-Type")
	fmt.Printf("%s -> %s\n", url, contentType)
}

func main() {
	urls := []string{
		"https://golang.org",
		"https://api.github.com",
		"https://httpbin.org/xml",
	}

	var waitGroup sync.WaitGroup // 2
	for _, url := range urls {
		waitGroup.Add(1) // 3
		go func(url string) {
			returnType(url)
			waitGroup.Done() // 4
		}(url)
	}
	waitGroup.Wait() // 1
}
