package main

import "fmt"

func main() {

    m := make(map[string]int)

    m["k1"] = 7
    m["k2"] = 13

    fmt.Println("map:", m)

    v1 := m["k1"]
    fmt.Println("v1: ", v1)

    fmt.Println("len:", len(m))

    delete(m, "k2")
    fmt.Println("map:", m)

    _, prs := m["k2"]
    fmt.Println("prs:", prs)

    n := map[string]int{"foo": 1, "bar": 2}
	fmt.Println("map:", n)
	
	// nilMap()

	// o := map[string]int{"foo": 1, "bar": 2}
	// insertItem(o)
	// fmt.Println("map:", o)


}

func nilMap(){
	var m map[int]string
	m[1] = "foo"
}

func insertItem(value map[string]int) {
	value["zi"] = 3
}

func traficCounter1(){

	hits := make(map[string]map[string]int)

	add(hits, "/doc/", "au")
	add(hits, "/doc/", "au")
	add(hits, "/doc/", "au")
	add(hits, "/dev/", "ir")
	add(hits, "/dev/", "ir")
	add(hits, "/dev/", "ir")
}

func add(m map[string]map[string]int, path, country string) {
    mm, ok := m[path]
    if !ok {
        mm = make(map[string]int)
        m[path] = mm
    }
    mm[country]++
}

type Key struct {
    Path, Country string
}

func traficCounter2(){
	hits := make(map[Key]int)
}