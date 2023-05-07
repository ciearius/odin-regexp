package tokenizer

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
	value:     string,
	using pos: Pos,
}
