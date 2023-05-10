package compiler

import "core:slice"

import "../bytecode"
import "../ast"

compile :: proc(tree: ast.Node) -> ([]Charset, []bytecode.Instruction) {
	cb := init_builder()

	code := to_code(cb, append_instr(code_from(cb, tree), bytecode.instr_match()))

	return to_const(cb), code
}

create_snippet :: proc(ii: ..^bytecode.Instruction) -> Snippet {
	s := make(Snippet, len(ii))

	for i, idx in ii {
		s[idx] = i
	}

	return s
}

append_instr :: proc(snip: Snippet, ii: ..^bytecode.Instruction) -> Snippet {
	return slice.concatenate([]Snippet{snip, ii})
}

prepend_instr :: proc(snip: Snippet, ii: ..^bytecode.Instruction) -> Snippet {
	return slice.concatenate([]Snippet{ii, snip})
}
