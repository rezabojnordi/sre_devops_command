package main

import (
	fmt "fmt"
	log "log"
	os "os"

	toml "github.com/pelletier/go-toml"
)

type Config struct {
	Login struct {
		User     string
		Password string
	}
}

func main() {
	file, err := os.Open("config.toml")
	if err != nil {
		log.Fatalf("ERROR: can't open config file - %s\n", err)
	}
	defer file.Close()

	ctg := &Config{}
	dec := toml.NewDecoder(file)
	if err := dec.Decode(ctg); err != nil {
		log.Fatalf("ERROR: can't decode config file - %s\n", err)
	}

	fmt.Printf("%+v", ctg)
}
