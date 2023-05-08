package tests

import "core:testing"
import "core:fmt"

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

	code := vm.code_from(cb, tree)

}
