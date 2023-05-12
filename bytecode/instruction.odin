package bytecode

Instruction :: struct {
	code:    OpCode,

	// Arguments
	idx:     int, // used for Set and Jump
	negated: bool, // for all matchers
	char:    rune, // char matcher
	range:   [2]rune, // range matcher
	split:   [2]int,
}

instr_char :: proc(r: rune, negated: bool) -> Instruction {
	return {code = .CHAR, char = r, negated = negated}
}

instr_set :: proc(id: int, negated: bool) -> Instruction {
	return {code = .SET, idx = id, negated = negated}
}

instr_range :: proc(r0, r1: rune, negated: bool) -> Instruction {
	return {code = .RANGE, range = [2]rune{r0, r1}, negated = negated}
}

instr_split :: proc(pc1, pc2: int) -> Instruction {
	return {code = .SPLIT, split = [2]int{pc1, pc2}}
}

instr_match :: proc() -> Instruction {
	return {code = .MATCH}
}

instr_jump :: proc(rel: int) -> Instruction {
	return {code = .JUMP, idx = rel}
}
