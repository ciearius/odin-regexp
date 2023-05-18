package tests

import "core:testing"
import "core:slice"
import "core:fmt"

import "../src/compiler"
import "../src/ast"
import "../src/bytecode"
import "../src/describe"

@(test)
t_code_from_group :: proc(t: ^testing.T) {
	return // unimplemented()
}

@(test)
t_code_from_match_range :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_match_range('0', '4', false),
		{},
		bytecode.instr_range('0', '4', false),
		bytecode.instr_match(),
	)
}

@(test)
t_code_from_match_set :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_match_set([]rune{'a', 'b', 'c'}, true),
		{{'a', 'b', 'c'}},
		bytecode.instr_set(0, true),
		bytecode.instr_match(),
	)
}

@(test)
t_code_from_match_char :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_match_set([]rune{'a'}, true),
		{},
		bytecode.instr_char('a', true),
		bytecode.instr_match(),
	)
}

@(test)
t_code_from_concatenation :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_concatenation(
			{
				ast.create_match_set([]rune{'a'}),
				ast.create_match_set([]rune{'a'}),
				ast.create_match_set([]rune{'a'}),
				ast.create_match_set([]rune{'a'}),
			},
		),
		{},
		bytecode.instr_char('a', false),
		bytecode.instr_char('a', false),
		bytecode.instr_char('a', false),
		bytecode.instr_char('a', false),
		bytecode.instr_match(),
	)
}

@(test)
t_code_from_alternation :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_alternation(
			{
				ast.create_match_set([]rune{'a'}),
				ast.create_match_set([]rune{'b'}),
				ast.create_match_set([]rune{'c'}),
				ast.create_match_set([]rune{'d'}),
			},
		),
		{},
		bytecode.instr_split(3, 1),
		bytecode.instr_split(5, 2),
		bytecode.instr_split(7, 9),
		bytecode.instr_char('a', false),
		bytecode.instr_jump(10),
		bytecode.instr_char('b', false),
		bytecode.instr_jump(10),
		bytecode.instr_char('c', false),
		bytecode.instr_jump(10),
		bytecode.instr_char('d', false),
		bytecode.instr_match(),
	)
}
