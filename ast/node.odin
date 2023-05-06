package ast

import "core:slice"

Node :: union {
	^Match_Rune,
	^Concatenation,
	^Alternation,
	^Optional,
	^Howevermany,
	^Atleastonce,
}

Match_Rune :: struct {
	r: rune,
}

create_match :: proc {
	create_match_rune,
	create_match_u8,
}

create_match_rune :: proc(r: rune) -> ^Match_Rune {
	mr := new(Match_Rune)

	mr.r = r

	return mr
}

create_match_u8 :: proc(r: u8) -> ^Match_Rune {
	return create_match(rune(r))
}

Concatenation :: struct {
	nodes: [dynamic]Node,
}

create_Concatenation :: proc(nodes: ..Node) -> ^Concatenation {
	mr := new(Concatenation)

	mr.nodes = slice.to_dynamic(nodes)

	return mr
}

Alternation :: struct {
	a, b: Node,
}

Optional :: struct {
	a: Node,
}

Howevermany :: struct {
	a: Node,
}

Atleastonce :: struct {
	a: Node,
}

create_Atleastonce :: proc(r: Node) -> ^Atleastonce {
	mr := new(Atleastonce)

	mr.a = r

	return mr
}
