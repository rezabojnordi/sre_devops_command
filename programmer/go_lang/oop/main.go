package main

import (
	"fmt"
	"oop/ncode"
)

func main() {
	var nID1 ncode.NationalID
	nID1 = "012-456789"
	fmt.Printf("My National ID Number %s is validnID :%v \n", nID1, nID1.IsValid())

	var nID2 ncode.NationalID
	nID2 = "0120456789"
	fmt.Printf("My National ID Number %s is validnID :%v \n", nID2, nID2.IsValid())

}
