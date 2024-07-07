package main

import (
	"fmt"
)


// one of the most useful data structures in computer science is the hash table.
// map[keyType]ValueType
// - KeyType : Comparable Type(No Slices, Map,functions)
// - ValueType: Any Type
// Define a Map
//map[keyType]ValueType
//var m map[string]int
func main() {
	var m map[string]int
	fmt.Println(m)
	if m == nil {
		m = make(map[string]int) // assuin memory for your map
	}

	fmt.Println("",m)

	m["k1"] = 7
	m["k2"] = 13

	fmt.Println("map:--->", m)

	v1 := m["k1"]
	fmt.Println("v1:", v1)
	fmt.Println("len:", len(m))

	delete(m, "k2")
	fmt.Println("map", m)


	// check and Get value

	k1, ok := m["k1"]
	fmt.Println("ok",ok,k1)
	// only check
	_, prss := m["k2"]
	fmt.Println("prss",prss)

	n := map[string]int{"foo": 1, "bar":2, "test":3, "ada": 4}
	fmt.Println("map",n)
	for key,value:=range n {
		fmt.Println("loop===>",key,value)
	}


// Multiple Initialize. 
//   commits := map[string]int{
// 	  "rsc": 3711,
// 	  "r": 2138,
// 	  "gri": 1908,
// 	  "adg" : 912
// 	}

// }