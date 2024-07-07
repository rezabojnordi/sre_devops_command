package main
import "fmt"

type Shape interface {
    Area() int
}

type Square struct{
    Length int
}

type Rectangle struct{
    Length int
    Width int
}


func (s Square) Area() int{
    return s.Length * s.Length
}


func (r Rectangle) Area() int{
    return r.Length * r.Width
}

//CalculateArea godoc
func CalculateArea(s Shape) int{
    return s.Area()
}

func main() {
    s := Square{Length:10}
    r := Rectangle{Length:10,Width:20}
    
    shapeList := []Shape{s,r}
    
    for _,value := range shapeList {
        fmt.Printf("%d , %T \n",value.Area() , value)
    }
    res := CalculateArea(r)
    fmt.Println(res)
    
}
