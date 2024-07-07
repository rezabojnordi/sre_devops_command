
package main
import "fmt"

const (
	waters = iota   // afther that you use iota. iota is 2
	air = iota
	soil = iota
	glass = iota
)

// const (
// 	a = iota +1 // a ==1
// 	_ // (implicity _ = iota + 1)
// 	b // b == 3 (implicity b = iota + 1)
// 	c   // c == 4 (implicitly c = iota + 1)
// )


func main() {
	fmt.Println(waters,air,soil,glass)
}