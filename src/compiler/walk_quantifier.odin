package compiler

import "../ast"
import "../bytecode"


code_from_optional :: proc(c: ^ConstBuilder, node: ^ast.Optional) -> Snippet {
	content := code_from(c, node.content)

	c2 := bytecode.instr_split(1, len(content) + 1)

	return prepend_instr(content, c2)
}

code_from_howevermany :: proc(c: ^ConstBuilder, node: ^ast.Howevermany) -> Snippet {
	panic("not implemented")
}

code_from_atleastonce :: proc(c: ^ConstBuilder, node: ^ast.Atleastonce) -> Snippet {
	panic("not implemented")
}
