package tokenizer

TokenType :: enum {
	// TODO: Add whitespace

	// char classes
	Num,
	Char_Lower,
	Char_Upper,

	// symbols
	Bar,
	Q,
	Star,
	Plus,
	Caret,
	Dollar,

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
	value:     string,
	using pos: Pos,
}
