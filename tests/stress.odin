package tests

import "core:testing"
import "core:slice"
import "core:fmt"

import "../src/describe"
import "../src/ast"
import "../src/parser"
import "../src/tokenizer"
import "../src/bytecode"
import "../src/compiler"
import "../src/util"

@(test)
test_stress :: proc(t: ^testing.T) {
	stresser := util.build_torture_regex(5)

	describe.tokenizer_test(
		t,
		stresser,
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a', 'a', 'a', 'a', 'a'),
		describe.token_EOF(),
	)

	describe.parser_test(
		t,
		{
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a', 'a', 'a', 'a', 'a'),
			describe.token_EOF(),
		},
		ast.create_concatenation(
			{
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
			},
		),
	)

	code := []bytecode.Instruction {
		bytecode.instr_split(1, 2),
		bytecode.instr_char('a', false),
		bytecode.instr_split(3, 4),
		bytecode.instr_char('a', false),
		bytecode.instr_split(5, 6),
		bytecode.instr_char('a', false), // 0
		bytecode.instr_split(7, 8), // 1
		bytecode.instr_char('a', false), // 2
		bytecode.instr_split(9, 10), // 3
		bytecode.instr_char('a', false), // 4
		bytecode.instr_char('a', false), // 5
		bytecode.instr_char('a', false), // 6
		bytecode.instr_char('a', false), // 7
		bytecode.instr_char('a', false), // 8
		bytecode.instr_char('a', false), // 9
		bytecode.instr_match(),
	}

	describe.compiler_test(
		t,
		ast.create_concatenation(
			{
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_optional(ast.create_match_set({'a'})),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
				ast.create_match_set({'a'}),
			},
		),
		{},
		..code,
	)

	describe.vm_test(t, code, {}, {'a', 'a', 'a', 'a', 'a', 'a', 'a'}, true)

	describe.vm_test(t, code, {}, {'a', 'a', 'a', 'a'}, false)
}

@(test)
test_build_input :: proc(t: ^testing.T) {
	c := util.build_input(10, 'a')

	fmt.println(c, len(c))

	testing.expect_value(t, len(c), 10)

	for i := 0; i < 10; i += 1 {
		testing.expect_value(t, c[i], 'a')
	}
}
