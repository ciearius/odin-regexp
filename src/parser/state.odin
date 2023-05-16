package parser

import tk "../tokenizer"
import "../ast"

ParseState :: struct {
	offset: int,
	tokens: []tk.Token,
	tree:   ast.Node,
	curr:   tk.Token,
}

create_parserstate :: proc(tokens: []tk.Token) -> ^ParseState {
	ps := new(ParseState)

	ps.tokens = tokens
	ps.curr = ps.tokens[ps.offset]

	return ps
}

matches :: proc(ps: ^ParseState, tp: tk.TokenType) -> bool {
	if current(ps).ttype == tp {
		advance(ps)
		return true
	}

	return false
}

current :: proc(ps: ^ParseState) -> tk.Token {
	return ps.tokens[ps.offset]
}

advance :: proc(ps: ^ParseState) {
	if ps.offset >= len(ps.tokens) {
		panic("tried to advance with no space left!")
	}
	ps.offset += 1
	ps.curr = current(ps)
}

eof :: proc(ps: ^ParseState) -> bool {
	return current(ps).ttype == .EOF
}
