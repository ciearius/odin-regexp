package compiler

import "../ast"
import "../bytecode"

code_from :: proc(c: ^ConstBuilder, node: ast.Node) -> Snippet {

	switch in node {

	case ^ast.Group:
		return code_from_group(c, node.(^ast.Group))

	case ^ast.Match_Range:
		return code_from_match_range(c, node.(^ast.Match_Range))

	case ^ast.Match_Set:
		return code_from_match_set(c, node.(^ast.Match_Set))

	case ^ast.Concatenation:
		return code_from_concatenation(c, node.(^ast.Concatenation))

	case ^ast.Alternation:
		return code_from_alternation(c, node.(^ast.Alternation))

	case ^ast.Optional:
		return code_from_optional(c, node.(^ast.Optional))

	case ^ast.Howevermany:
		return code_from_howevermany(c, node.(^ast.Howevermany))

	case ^ast.Atleastonce:
		return code_from_atleastonce(c, node.(^ast.Atleastonce))

	}

	panic("unrecognised ast.Node")
}

code_from_group :: proc(c: ^ConstBuilder, node: ^ast.Group) -> Snippet {
	return code_from(c, node.content)
}
