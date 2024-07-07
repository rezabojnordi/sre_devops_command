package main

import (
	"fmt"
)

func main() {
	var i int
	i = 45
	fmt.Println("number",i)

	var f float32 = 333.54
	fmt.Println("",f)

	firstName := "REza"
	fmt.Println(firstName)

	b := true
	fmt.Println(b)

	c :=complex(3,5)
	fmt.Println(c)

	r,im := real(c),imag(c)
	fmt.Println(r,im)
}