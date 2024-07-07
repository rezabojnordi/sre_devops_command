package main

import (
	"fmt"
	"github.com/pluralsight/webservice/models"


)

func main() {
	u := models.User{
		ID: 2,
		FirstName: "John",
		LastName: "Doe",
	}
	fmt.Println("Hello from a module, Gophers!",u)
}