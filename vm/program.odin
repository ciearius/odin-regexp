package vm

import "core:slice"

Snippet :: []Instruction
Charset :: []rune

Instruction :: struct {
	code: OpCode,
	args: Argument,
}

Program :: struct {
	code:  []Instruction,
	const: ^Constants,
}

Constants :: struct {
	sets: []Charset,
}

code :: proc(c: OpCode, arg: Argument) -> Instruction {
	return Instruction{c, arg}
}
