package main

import (
	"fmt"
	"math"
)

func main() {
	var ingeger int = 15
	var txt string = "R"
	fmt.Println(ingeger, txt)

	const float64EqualityThreshold = 1e-9
	var (
		var1 float64 = -1.2
		var2 int     = 1
	)
	var3 := var1 + float64(var2)

	if math.Abs(var3-(-0.2)) < float64EqualityThreshold {
		fmt.Println("It is Equal")
	}
	fmt.Println("It is not Equal")
}
