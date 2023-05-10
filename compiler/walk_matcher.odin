package compiler

import "core:slice"

import "../ast"
import "../bytecode"

code_from_match_range :: proc(c: ^ConstBuilder, node: ^ast.Match_Range) -> Snippet {
	return create_snippet(bytecode.instr_range(node.range[0], node.range[1], node.negated))
}

code_from_match_set :: proc(c: ^ConstBuilder, node: ^ast.Match_Set) -> Snippet {
	if len(node.cset) == 1 {
		return create_snippet(bytecode.instr_char(node.cset[0], node.negated))
	}

	return create_snippet(bytecode.instr_set(add(c, node.cset), node.negated))
}
