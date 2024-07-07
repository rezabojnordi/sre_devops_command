package main

import "fmt"

func main() {
	foo := []string{"Amir", "Azimi", "Parsclick"}
	fmt.Printf("foo = %v (type %T)\n", foo, foo)

	// Lenght
	fmt.Println(len(foo))
	// 0 indexed
	fmt.Println(foo[1])
	// slices
	fmt.Println(foo[1:])

	fmt.Println("=========")

	// For loop
	for i := 0; i < len(foo); i++ {
		fmt.Println(foo[i])
	}

	fmt.Println("=========")

	// Single Value range (to show indexes only)
	for index := range foo {
		fmt.Println(index)
	}

	// Double Value range (to show index and value together)
	for index, value := range foo {
		fmt.Printf("%d - %s\n", index, value)
	}

	fmt.Println("=========")

	// Double Value range ignore index by using _
	for _, value := range foo {
		fmt.Println(value)
	}

	fmt.Println("=========")

	// Append
	foo = append(foo, "London")
	fmt.Println(foo)

}
