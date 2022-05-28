package main

type User struct {
	ID int
	FirstName string
	LastName string
}

func main(){
	u1 := User{
		ID: 1,
		FirstName: "Reza",
		LastName: "Dent",
	}
	u2 := User{
		ID: 2,
		FirstName: "ford",
		LastName: "prefect",
	}

	if u1.ID == u2.ID {
		println("same user!")
		}else{
		println("not same user!")

	}


}