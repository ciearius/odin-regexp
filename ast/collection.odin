package ast

NodeCollection :: struct {
	nodes: []Node,
}

create_node_collection :: proc($C: typeid, nodes: []Node) -> ^C {
	col := new(C)

	col.nodes = nodes

	return col
}
