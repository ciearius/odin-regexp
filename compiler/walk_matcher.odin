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

code_from_match_charclass :: proc(cb: ^ConstBuilder, node: ^ast.Match_CharClass) -> Snippet {
	switch node.class {

	case .Digit:
		return create_snippet(bytecode.instr_range('0', '9', node.negated))

	case .Word:
		word_class := [?]ast.Node{
			ast.create_match_range('a', 'z', node.negated),
			ast.create_match_range('A', 'Z', node.negated),
			ast.create_match_range('0', '9', node.negated),
			ast.create_match_set([]rune{'_'}, node.negated),
		}

		return code_from_alternation(cb, ast.create_alternation(word_class[:]))

	}

	panic("not a charclass")
}
