package main

import "fmt"

func main() {
	//var a [5]int = [5]int{1, 2, 3, 4, 5}
	a := [5]int{1, 2, 3, 4, 5}
	fmt.Println(a)

	mySlice := []int{1, 2, 3, 4, 5}
	mySlice = append(mySlice, 6, 7, 8)
	mySlice = append(mySlice, 9)
	fmt.Println(mySlice)
	// ----------------------------------
	s := make([]int, 5)
	s[0], s[1], s[2], s[3], s[4] = 1, 2, 3, 4, 5
	fmt.Println(s)

	s1 := s[1:3]
	fmt.Println(s1) //len(s1) , cap(s1)

	fmt.Println(len(s1))
	fmt.Println(cap(s1))

	fmt.Println(s1[:cap(s1)])
	// ------------------------------------
	s2 := make([]int, 2)
	copy(s2, s[1:3])
	fmt.Println(s2)

	fmt.Println(len(s2))
	fmt.Println(cap(s2))

	fmt.Println(s2[:cap(s2)])
}
