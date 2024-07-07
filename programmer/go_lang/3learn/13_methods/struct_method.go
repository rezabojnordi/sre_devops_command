package main

import "fmt"

type Point struct {
	X int
	Y int
}

func (point *Point) Move(dx int, dy int) {
	point.X += dx
	point.Y += dy
}

func main() {
	point := &Point{1, 2}
	point.Move(2, 3)
	fmt.Printf("%+v\n", point)
}
