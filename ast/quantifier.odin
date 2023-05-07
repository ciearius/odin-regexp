package ast

Quantifier :: struct {
	content: Node,
}

Optional :: struct {
	using q: Quantifier,
}

Howevermany :: struct {
	using q: Quantifier,
}

Atleastonce :: struct {
	using q: Quantifier,
}

create_quantifier :: proc($Q: typeid, r: Node) -> ^Q {
	quant := new(Q)

	quant.content = r

	return quant
}

create_optional :: proc(r: Node) -> ^Optional {
	return create_quantifier(Optional, r)
}

create_howevermany :: proc(r: Node) -> ^Howevermany {
	return create_quantifier(Howevermany, r)
}

create_atleastonce :: proc(r: Node) -> ^Atleastonce {
	return create_quantifier(Atleastonce, r)
}
