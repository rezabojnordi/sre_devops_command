package controllers

import ( "net/http"
        "regexp"
)

type user_Controller struct {
user_id_pattern *regexp.Regexp

}

func (uc user_Controller) ServeHTTP (w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, world!"))
}


func new_user_controller() *user_Controller{
   return &user_Controller{
	   user_id_pattern: regexp.MustCompile(`^/users/(\d+)/?`)
   }
}