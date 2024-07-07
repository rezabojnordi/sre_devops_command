

package controllers

import "net/http"

func register_controller()  {
	uc := new_user_controller()
	
	http.Handle("/users", *uc)
	http.Handle("/users/", *uc)
}