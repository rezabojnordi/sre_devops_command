package main

import (
	"fmt"
)


func main() {
	fmt.Println("Hello, playground")
	port := 3000
	r := start_web_service(port,100)
	fmt.Println(r)
}


func start_web_service(port  int, number_of_request int) bool{
	fmt.Println("Starting server...")
	fmt.Println("Server started...")
	fmt.Println("Server started on port", port)
	fmt.Println("Server started on port", number_of_request)
	return true
}