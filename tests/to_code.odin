package tests

import "core:testing"
import "core:slice"
import "core:fmt"

import "../compiler"
import "../ast"
import "../bytecode"

@(test)
t_code_from_group :: proc(t: ^testing.T) {
	return // unimplemented()
}

@(test)
t_code_from_match_range :: proc(t: ^testing.T) {
	cb := compiler.init_builder()

	input := ast.create_match_range('0', '4', false)
	actual := compiler.code_from_match_range(cb, input)

	testing.expect_value(t, len(actual), 1)
	testing.expect_value(t, input.negated, false)
	testing.expect_value(t, input.range, [2]rune{'0', '4'})
}

@(test)
t_code_from_match_set :: proc(t: ^testing.T) {
	cb := compiler.init_builder()
	using testing

	input := ast.create_match_set([]rune{'a', 'b', 'c'}, true)
	actual := compiler.code_from_match_set(cb, input)

	expect_value(t, len(actual), 1)
	expect_value(t, actual[0].code, bytecode.OpCode.SET)
	expect_value(t, actual[0].idx, 0)
	expect_value(t, actual[0].negated, true)

	expect_value(t, len(cb.sets), 1)
	expect_value(t, len(cb.sets[0]), 3)
	expect_value(t, cb.sets[0][0], 'a')
	expect_value(t, cb.sets[0][1], 'b')
	expect_value(t, cb.sets[0][2], 'c')
}

@(test)
t_code_from_match_char :: proc(t: ^testing.T) {
	cb := compiler.init_builder()
	using testing

	input := ast.create_match_set([]rune{'a'}, true)
	actual := compiler.code_from_match_set(cb, input)

	expect_value(t, len(actual), 1)
	expect_value(t, actual[0].code, bytecode.OpCode.CHAR)

	expect_value(t, actual[0].char, 'a')
	expect_value(t, actual[0].negated, true)

	expect_value(t, len(cb.sets), 0)
}

@(test)
t_code_from_concatenation :: proc(t: ^testing.T) {
	cb := compiler.init_builder()
	using testing

	input := ast.create_concatenation(
		{
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
		},
	)
	actual := compiler.code_from_concatenation(cb, input)

	expect_value(t, len(actual), 4)
	expect_value(t, actual[0].code, bytecode.OpCode.CHAR)
}

@(test)
t_code_from_alternation :: proc(t: ^testing.T) {
	cb := compiler.init_builder()
	using testing

	input := ast.create_alternation(
		{
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
			ast.create_match_set([]rune{'a'}),
		},
	)

	actual := compiler.code_from_alternation(cb, input)

	// Number of instructions for n cases:
	// i (n) = 2n - 1 + (n - 1)
	expect_value(t, len(actual), 3 * 4 - 2)
}
