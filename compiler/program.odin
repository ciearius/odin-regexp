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

to_const :: proc(c: ^ConstBuilder) -> ^Constants {
	const := new(Constants)

	const.sets = c.sets[:]

	return const
}

to_program :: proc(c: ^ConstBuilder, code: Snippet) -> ^Program {
	p := new(Program)

	p.const = to_const(c)
	p.code = make([]bytecode.Instruction, len(code))

	for instr, i in code {
		p.code[i] = instr^
	}

	return p
}
