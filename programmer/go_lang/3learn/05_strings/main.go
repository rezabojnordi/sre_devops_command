package main

import "fmt"

func main() {
	book := "Yare Dabestanie Man"

	fmt.Println(book)

	// String length
	fmt.Println(len(book))

	fmt.Printf("book[0] = %v (type) %T \n", book[0], book[0])

	// (strings are immutable)
	// book[0] = 116

	// Slice (start, end), 0 based, half empty range
	fmt.Println(book[4:11])

	// Slice (no end)
	fmt.Println(book[4:])

	// Slice (no start)
	fmt.Println(book[:4])

	// Use + to concatinate string
	fmt.Println("Hey " + book)

	// Multi line
	poem := `
	Yare dabestanie man
	Ba mano hamrahe mani
	...
	`
	fmt.Println(poem)
}
