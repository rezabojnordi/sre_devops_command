package main

import "fmt"

func main() {
	m := map[string]int{"foo":42}
	fmt.Println(m["foo"])
	fmt.Println(m)
	m["foo"] = 27
	fmt.Println(m)
	delete(m,"foo")
	fmt.Println(m)
}