package tests

import "core:testing"
import "core:slice"
import "core:fmt"

import "../vm"
import "../ast"

@(test)
t_code_from_group :: proc(t: ^testing.T) {
	return // unimplemented()
}

@(test)
t_code_from_match_range :: proc(t: ^testing.T) {
	cb := vm.init_builder()

	input := ast.create_match_range('0', '4', false)
	actual := vm.code_from_match_range(cb, input)

	testing.expect_value(t, len(actual), 1)

	// TODO: write tests

	return // unimplemented()
}
