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

to_code :: proc(c: ^ConstBuilder, code: Snippet) -> []bytecode.Instruction {
	res := make([]bytecode.Instruction, len(code))

	for instr, i in code {
		res[i] = instr^
	}

	return res
}
