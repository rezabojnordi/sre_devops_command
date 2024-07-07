package main

import "fmt"


func main() {
	type user struct {
		id int
		first_name string
		last_name string
	}
	var u user
	u.id = 100
	u.first_name = "Reza"
	u.last_name = "Bojnordi"
	fmt.Println(u)

	u2 := user{id: 200, first_name: "me", last_name: "you"}
	fmt.Println(u2)
}
