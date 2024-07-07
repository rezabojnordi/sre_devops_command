package main

import (
	"net/http"
	"github.com/pluralsight/webservice/controllers"


)

func main() {

	controllers.register_controller()
	http.ListenAndServe(":3000",nil)
}