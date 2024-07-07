package main

import "fmt"

func doubleAt(values []int, i int) { // slices, map are passed by reference (they will change)
	values[i] *= 2
}

func double(n int) { // passed by value (int) (meaning they won't change unless passing pinter)
	n *= 2
}

func doublePtr(n *int) { // passing as pointer by using *
	*n *= 2
}

func main() {
	values := []int{1, 2, 3, 4}
	doubleAt(values, 2)
	fmt.Println(values)

	val := 10
	double(val)
	fmt.Println(val)

	doublePtr(&val) // pass by pointer using &
	fmt.Println(val)

}
