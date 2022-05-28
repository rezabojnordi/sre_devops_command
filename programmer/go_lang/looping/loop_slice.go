package main

// func main() {
// 	slices := []int{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
// 	for i:=0; i<len(slices); i++ {
// 		println(slices[i])
// 	}
// }

// func main() {
// 	slices := []int{1,2,3,4,5,6,7,8}
// 	for i,v := range slices {
// 		println(i,":",v)
// 	}
// }


// when you want not to use i variable you can use _ 
func main() {
	wellknown := map[string]int{"http": 80, "https":443}
	for i,v :=range wellknown {
		println(i,":",v)
	}
}