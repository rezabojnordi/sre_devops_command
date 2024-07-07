package main

import (
	"fmt"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fprintf, err := fmt.Fprintf(w, "Hello Parsclick fans!")
	if err != nil {
		fmt.Printf("ERROR: %s", err)
	}
	fmt.Println(fprintf)
}

func main() {
	http.HandleFunc("/hello", helloHandler)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
