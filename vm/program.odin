package vm

import "core:slice"

Snippet :: []Instruction
Charset :: []rune

Argument :: union {
	^Param_Char,
	^Param_Set,
	^Param_Range,
	Param_Jump,
	Param_Split,
}

Param_Char :: struct {
	r:       rune,
	negated: bool,
}

create_param_char :: proc(r: rune, negated: bool) -> ^Param_Char {
	s := new(Param_Char)

	s.r = r
	s.negated = negated

	return s
}

Param_Set :: struct {
	id:      int,
	negated: bool,
}

create_param_set :: proc(id: int, negated: bool) -> ^Param_Set {
	s := new(Param_Set)
	s.id = id
	s.negated = negated
	return s
}

Param_Range :: struct {
	r:       [2]rune,
	negated: bool,
}
create_param_range :: proc(r: [2]rune, negated: bool) -> ^Param_Range {
	s := new(Param_Range)
	s.r = r
	s.negated = negated
	return s
}

Param_Jump :: int

Param_Split :: [2]int


Instruction :: struct {
	code: OpCode,
	args: Argument,
}

code :: proc(c: OpCode, arg: Argument) -> Instruction {
	return Instruction{c, arg}
}

Program :: struct {
	code:  []Instruction,
	const: ^Constants,
}

Constants :: struct {
	sets: []Charset,
}
