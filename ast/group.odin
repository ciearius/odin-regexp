package ast

Group :: struct {
	content: Node,
}

create_group :: proc(c: Node) -> ^Group {
	g := new(Group)

	g.content = c

	return g
}
