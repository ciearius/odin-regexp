package vm

Instruction :: struct {
	code:    OpCode,

	// Arguments
	idx:     int, // used for Set and Jump
	negated: bool, // for all matchers
	char:    rune, // char matcher
	range:   [2]rune, // range matcher
	split:   [2]int,
}

create_instr_char :: proc(r: rune, negated: bool) -> ^Instruction {
	a := new(Instruction)

	a.code = .CHAR
	a.char = r
	a.negated = negated

	return a
}

create_instr_set :: proc(id: int, negated: bool) -> ^Instruction {
	a := new(Instruction)

	a.code = .SET
	a.idx = id
	a.negated = negated

	return a
}

create_instr_range :: proc(r0, r1: rune, negated: bool) -> ^Instruction {
	a := new(Instruction)

	a.code = .RANGE
	a.range = [2]rune{r0, r1}
	a.negated = negated

	return a
}

create_instr_split :: proc(pc1, pc2: int) -> ^Instruction {
	a := new(Instruction)

	a.code = .SPLIT
	a.split = [2]int{pc1, pc2}

	return a
}

create_instr_match :: proc() -> ^Instruction {
	a := new(Instruction)

	a.code = .MATCH

	return a
}

create_instr_jump :: proc(rel: int) -> ^Instruction {
	a := new(Instruction)

	a.code = .JUMP
	a.idx = rel

	return a
}

create_snippet :: proc(ii: ..^Instruction) -> Snippet {
	s := make([]^Instruction, len(ii))

	for i, idx in ii {
		s[idx] = i
	}

	return s
}
