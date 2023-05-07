package ast

import "core:unicode/utf8"
import "core:slice"

Match_Range :: struct {
	// Lower and upper bounds to be matched against.
	negated: bool,
	range:   [2]rune,
}

Match_Set :: struct {
	negated: bool,
	cset:    []rune,
}

create_match_range :: proc(lower, upper: rune, negated: bool = false) -> ^Match_Range {
	mr := new(Match_Range)

	mr.range = {lower, upper}
	mr.negated = negated

	return mr
}

create_match_set :: proc(str: string, negated: bool = false) -> ^Match_Set {
	return create_match_rune_set(utf8.string_to_runes(str), negated)
}

create_match_rune_set :: proc(cset: []rune, negated: bool = false) -> ^Match_Set {
	mr := new(Match_Set)

	mr.cset = cset

	slice.sort(mr.cset)

	mr.negated = negated

	return mr
}
