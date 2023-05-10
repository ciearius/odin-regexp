package compiler

import "core:slice"

import "../bytecode"
import "../ast"

compile :: proc(tree: ast.Node) -> ^Program {
	cb := init_builder()

	code := code_from(cb, tree)

	prog := to_program(cb, append_instr(code, bytecode.instr_match()))

	return prog
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
