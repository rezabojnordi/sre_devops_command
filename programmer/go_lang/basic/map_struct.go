package main

import "fmt"

type person struct {
	Family string
	Name   string
	Age    int
}

func main() {
	//var m = make(map[string]int)
	// m := make(map[string]int)
	// m["First"] = 1
	// m["Second"] = 2

	// fmt.Println(m["Second"])

	// m := map[string]int{
	// 	"First":  1,
	// 	"Second": 2,
	// }

	// fmt.Println(m)
	// delete(m, "Second")
	// fmt.Println(m)
	// if v, ok := m["Second"]; ok {
	// 	fmt.Println(v)
	// }
	//----------------------------------------------
	reza := person{
		Age:    50,
		Family: "Rezaee",
		Name:   "Reza",
	}

	fmt.Println(reza)

	people := map[string]person{
		"Reza": person{
			Age:    50,
			Family: "Rezaee",
			Name:   "Reza",
		},
		"Mohammad": {
			Age:    50,
			Family: "Mohammadi",
			Name:   "Mohammad",
		},
	}

	fmt.Println(people)
	fmt.Println(people["Mohammad"])
	fmt.Println(people["Mohammad"].Family)

}
