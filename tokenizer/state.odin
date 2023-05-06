package tokenizer

Pos :: struct {
	offset, end: int,
}

TokenizerState :: struct {
	input:     string,
	res:       ^[dynamic]Token,
	using pos: Pos,
}

grab_rune :: proc(ts: ^TokenizerState, ttype: TokenType) {
	append(ts.res, Token{ttype, ts.input[ts.offset:ts.offset + 1], Pos{ts.offset, ts.offset}})
	ts.offset += 1
}

current :: proc(ts: ^TokenizerState) -> rune {
	return rune(ts.input[ts.offset])
}

eof :: proc(ts: ^TokenizerState) -> bool {
	return ts.offset >= ts.end
}
