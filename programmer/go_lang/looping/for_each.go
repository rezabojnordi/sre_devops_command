package main

import "fmt"

func main() {

	stringgs := []string{"hello", "world", "world"}
	for i, v := range stringgs {
		fmt.Println(i, v)
	}

}
