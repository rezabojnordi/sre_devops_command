package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"os"
)

var data = `
{
	"user": "Amir Azimi",
	"type": "deposit",
	"amount": 1000000.5
}
`

// Request is a bank transaction
type Request struct {
	Login  string  `json:"user"`
	Type   string  `json:"type"`
	Amount float64 `json:"amount"`
}

func main() {
	// Simulate a file/socket
	reader := bytes.NewBufferString(data)

	// Decode the request
	decode := json.NewDecoder(reader)

	request := &Request{} // use struct for a request
	if err := decode.Decode(request); err != nil {
		log.Fatalf("ERROR: can't decode - %s", err)
	}

	fmt.Printf("got: %+v\n", request)

	// Create response
	prevBalance := 8500000.0            // Loaded from database
	response := map[string]interface{}{ // use map with empty interface for a response
		"ok":      true,
		"code":    200,
		"balance": prevBalance + request.Amount,
	}

	// Encode the request
	encode := json.NewEncoder(os.Stdout)
	if err := encode.Encode(response); err != nil {
		log.Fatalf("ERROR: can't encode - %s", err)
	}
}
