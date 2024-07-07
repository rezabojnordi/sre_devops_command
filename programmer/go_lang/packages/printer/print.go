package printer

import ("fmt"
       "time"
)

// PrintHelloWorld print my Helloworld 
// if you want to need to use  function out this page, you must do capital function
func PrintHelloWorld(){
   printBegining()
   fmt.Println("helloword")
}

func printBegining() {
   fmt.Println(time.Now().Format("2006"))
}