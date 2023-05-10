package tokenizer

Pos :: struct {
	offset, end: int,
}

TokenizerState :: struct {
	input:     []rune,
	res:       [dynamic]Token,
	using pos: Pos,
}

grab_rune :: proc(ts: ^TokenizerState, ttype: TokenType) {
	append(&ts.res, Token{ttype, ts.input[ts.offset:ts.offset + 1], Pos{ts.offset, ts.offset}})
	advance(ts)
}

grab :: proc(ts: ^TokenizerState, ttype: TokenType, begin, end: int) {
	append(&ts.res, Token{ttype, ts.input[begin:end], Pos{begin, end}})
}

current :: proc(ts: ^TokenizerState) -> rune {
	return rune(ts.input[ts.offset])
}

advance :: proc(ts: ^TokenizerState) {
	if ts.offset >= len(ts.input) {
		panic("tried to advance with no space left!")
	}
	ts.offset += 1
}

eof :: proc(ts: ^TokenizerState) -> bool {
	return ts.offset >= ts.end
}
