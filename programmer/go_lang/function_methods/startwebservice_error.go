package main

import (
	"fmt"
)


func main() {
	port := 3000
	_,err := start_web_service(port,100)
	fmt.Println(err)
}

 
func start_web_service(port  int, number_of_request int) (int, error) {
	fmt.Println("Starting server...")
	fmt.Println("Server started...")
	fmt.Println("Server started on port", port)
	fmt.Println("Server started on port", number_of_request)
	return port, nil
}