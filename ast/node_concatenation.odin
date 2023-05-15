package ast

import "core:slice"
import "../util"

Concatenation :: struct {
	using n: NodeCollection,
}

create_concatenation :: proc(n: []Node) -> ^Concatenation {
	return create_node_collection(Concatenation, n)
}
