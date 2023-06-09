package compiler

import "core:slice"

import "../bytecode"

Program :: struct {
	code:  []bytecode.Instruction,
	const: ^Constants,
}

Constants :: struct {
	sets: []Charset,
}

to_const :: proc(c: ^ConstBuilder) -> []Charset {
	return c.sets[:]
}
