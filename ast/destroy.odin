package ast

destroy_node :: proc(n: Node) {
	switch in n {

	case ^Group:
		destroy_node(n.(^Group).content)

	case ^Match_Set:
		m := n.(^Match_Set)
		defer free(m)
		delete(m.cset)

	case ^Match_Range:
		m := n.(^Match_Range)
		free(m)

	case ^Concatenation:
		m := n.(^Concatenation)
		destroy_node_collection(m)

	case ^Alternation:
		m := n.(^Alternation)
		destroy_node_collection(m)

	case ^Optional:
		m := n.(^Optional)
		destroy_quantifier(m)

	case ^Howevermany:
		m := n.(^Howevermany)
		destroy_quantifier(m)

	case ^Atleastonce:
		m := n.(^Atleastonce)
		destroy_quantifier(m)
	}
}

destroy_node_collection :: proc(n: ^NodeCollection) {
	defer free(n)
	delete(n.nodes)
}

destroy_quantifier :: proc(n: ^Quantifier) {
	defer free(n)
	destroy_node(n.content)
}
