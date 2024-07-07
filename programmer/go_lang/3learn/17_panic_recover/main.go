package main

import "fmt"

func safeValues(vals []int, index int) int {
	defer func() {
		if err := recover(); err != nil {
			fmt.Printf("ERROR: %s\n", err)
		}
	}()

	return vals[index]
}

func main() {
	// vals := []int{1, 2, 3}
	// // panic
	// v := vals[5]
	// fmt.Println(v)

	// file, err := os.Open("no-file")
	// if err != nil {
	// 	panic(err) // using panic is discouraged
	// }
	// defer file.Close()
	// fmt.Println("file opened")

	v := safeValues([]int{1, 2, 3}, 5)
	fmt.Println(v)
}
