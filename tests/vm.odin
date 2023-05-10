package tests

import "core:testing"
import "core:fmt"
import "core:slice"


import "../tokenizer"
import "../parser"
import "../ast"
import "../vm"
import "../compiler"
import "../bytecode"

@(test)
test_vm :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`a[a-zA-Z]`)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	prog := compiler.compile(tree)

	r := vm.run(prog, []rune{'a', 'A'})

	testing.expect(t, r, "match found")
}
