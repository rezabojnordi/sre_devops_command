package main

import (
	"fmt"
	"myapp/data"
)

func main() {
	fmt.Println("hello Go")
	var lname string = "RB"
	println("----", data.Name)
	sayHello("Reza", lname)
}

func sayHello(name string, lname string) {
	fmt.Println(name, lname)

}
