package vm

Argument :: struct {
	idx:     int, // used for Set and Jump
	negated: bool, // for all matchers
	char:    rune, // char matcher
	range:   [2]rune, // range matcher
	split:   [2]int,
}

create_param_char :: proc(r: rune, negated: bool) -> Argument {
	return Argument{char = r, negated = negated}
}

create_param_set :: proc(id: int, negated: bool) -> Argument {
	return Argument{idx = id, negated = negated}
}

create_param_range :: proc(range: [2]rune, negated: bool) -> Argument {
	return Argument{range = range, negated = negated}
}

create_param_split :: proc(pc1, pc2: int) -> Argument {
	return Argument{split = [2]int{pc1, pc2}}
}
