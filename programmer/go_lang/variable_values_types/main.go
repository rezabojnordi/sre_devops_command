

// var variableName dataType = initialValue

// int 0
// string ""
var integer1 int = 15
var integer2 int8 = -25
var integer3 int32 //default 0
var float1 float32 = 63.2

var string1 string = "Hello world"

var boolean1 bool //default false
var boolean2 bool =true


// Type Inference

// var variableName = initialValue
var integer1 = 52 // int
var string1 = "Hello World" // string
var boolean1 = false // bool


// Short Hand Notation
// variableName := initialValue
integer1 := 52 //int
string1 := "Hello World" //string
boolean1 := false //bool

// Multiple Variable Declaration

// Multiple Variable Declaration
var var1, var2, var3 int
var var1, var2, var3 int = 1, 2, 3
var var1, var2, var3 = 1, 2.2, false
var1, var2, var3 := 1, 2.2, false
var (
var1 = 50
var2 = 25.22
var3 string = "Telefonía"
)
var4 bool


// Type Conversion without var
var1 := 10 // int
var2 := 10.5 // float64
// illegal
// var3 := var1 + var2
// legal
var3 := var1 + int(var2) // var3 => 20
var1 := "Hello"
var2 := []int32(va1)

// go is diffrent beetween linux and windows
// type aliasName aliasTo

type fload float64

