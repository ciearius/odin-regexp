package tokenizer

import "core:fmt"


TokenType :: enum {
	// TODO: Add whitespace

	// char classes
	Alphanumeric,

	// symbols
	Bar,
	Q,
	Star,
	Plus,
	Caret,
	Dollar,
	Dash,

	// Grouping
	Open_Paren,
	Close_Paren,
	Open_Bracket,
	Close_Bracket,
	Open_Brace,
	Close_Brace,

	// special
	Escaped,
	EOF,
}

Token :: struct {
	ttype:     TokenType,
	value:     []rune,
	using pos: Pos,
}

create_token :: proc(ttype: TokenType, value: []rune, pos: Pos) -> Token {
	return Token{ttype, value, pos}
}

to_string :: proc(t: Token) -> string {
	return fmt.aprintf("%v %v", t.ttype, t.value)
}
