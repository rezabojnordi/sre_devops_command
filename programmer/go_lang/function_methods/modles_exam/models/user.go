package models

type User struct {
	ID int
	FirstName string
	LastName string
}
 

var (
	users []*User
	nextId = 1
) 

func get_user() []*User {
	return users
}
func add_user(u User) (User, error){
	u.Id = next_id
	next_id++
	users = append(users, &u)
	return u, nil
}