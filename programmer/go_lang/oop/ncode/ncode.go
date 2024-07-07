package ncode

import (
	"strconv"
)

type NationalID string

var placeValue = [9]int{10, 9, 8, 7, 6, 5, 4, 3, 2}

// this function include on variable
func (id NationalID) IsValid() bool {
	if len(id) == 10 {
		for _, val := range id {
			_, err := strconv.Atoi(string(val))
			if err != nil {
				return false
			}

		}
		return true
	}
	return false

}

func (id NationalID) isCheckSumValid() bool {
	var sum int
	for key, value := range id {
		digit, err := strconv.Atoi(string(value))
		if err != nil {
			return false
		}
		sum = sum + digit*placeValue[key]
	}

}
