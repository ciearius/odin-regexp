package vm

import "core:slice"

Snippet :: []^Instruction
Charset :: []rune

Program :: struct {
	code:  []^Instruction,
	const: ^Constants,
}

Constants :: struct {
	sets: []Charset,
}
