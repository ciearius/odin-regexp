package ast

import "core:fmt"

Match_CharClass :: struct {
	negated: bool,
	class:   CharClass,
}

CharClass :: enum {
	Word,
	Digit,
}

create_match_char_class :: proc(name: rune) -> ^Match_CharClass {
	switch name {
	case 'w':
		return create_match_charclass(.Word)
	case 'W':
		return create_match_charclass(.Word, true)
	case 'd':
		return create_match_charclass(.Digit)
	case 'D':
		return create_match_charclass(.Digit, true)
	}

	fmt.panicf("%r is not a valid char class")
}

create_match_charclass :: proc(class: CharClass, negated: bool = false) -> ^Match_CharClass {
	m := new(Match_CharClass)

	m.class = class
	m.negated = negated

	return m
}
