package tests

import "core:testing"
import "core:fmt"
import "core:slice"


import "../tokenizer"
import "../parser"
import "../ast"
import "../vm"

@(test)
test_vm :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`a[a-zA-Z]`)

	tree, err := parser.parse(tokens)

	if err != .None {
		fmt.println("FAILED", err)
	}

	testing.expect_value(t, err, parser.ParseErr.None)

	cb := vm.init_builder()

	ast.prettyPrint(tree)

	code := vm.code_from(cb, tree)
	code = slice.concatenate([]vm.Snippet{code, {vm.create_instr_match()}})

	fmt.println(vm.to_string(code))

	prog := vm.to_program(cb, code)

	r := vm.run(prog, []rune{'a', 'A'})

	fmt.println(r)
}
