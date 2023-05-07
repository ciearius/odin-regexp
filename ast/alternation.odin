package ast

Alternation :: struct {
	using n: NodeCollection,
}

create_alternation :: proc(nodes: []Node) -> ^Alternation {
	return create_node_collection(Alternation, nodes)
}
