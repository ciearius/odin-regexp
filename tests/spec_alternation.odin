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

@(test)
test_alternation_tokenize :: proc(t: ^testing.T) {
	describe.tokenizer_test(
		t,
		`A|B`,
		describe.token(.Alphanumeric, 'A'),
		describe.token(.Bar, '|'),
		describe.token(.Alphanumeric, 'B'),
		describe.token_EOF(),
	)

	describe.tokenizer_test(
		t,
		`A|B|C|DEF`,
		describe.token(.Alphanumeric, 'A'),
		describe.token(.Bar, '|'),
		describe.token(.Alphanumeric, 'B'),
		describe.token(.Bar, '|'),
		describe.token(.Alphanumeric, 'C'),
		describe.token(.Bar, '|'),
		describe.token(.Alphanumeric, 'D', 'E', 'F'),
		describe.token_EOF(),
	)
}

@(test)
test_alternation_parse :: proc(t: ^testing.T) {
	describe.parser_test(
		t,
		{
			describe.token(.Alphanumeric, 'A'),
			describe.token(.Bar, '|'),
			describe.token(.Alphanumeric, 'B'),
			describe.token_EOF(),
		},
		ast.create_alternation(
			{ast.create_match_set({'A'}, false), ast.create_match_set({'B'}, false)},
		),
	)

	describe.parser_test(
		t,
		{
			describe.token(.Alphanumeric, 'A'),
			describe.token(.Bar, '|'),
			describe.token(.Alphanumeric, 'B'),
			describe.token(.Bar, '|'),
			describe.token(.Alphanumeric, 'C'),
			describe.token(.Bar, '|'),
			describe.token(.Alphanumeric, 'D', 'E', 'F'),
			describe.token_EOF(),
		},
		ast.create_alternation(
			{
				ast.create_match_set({'A'}, false),
				ast.create_match_set({'B'}, false),
				ast.create_match_set({'C'}, false),
				ast.create_match_set({'D', 'E', 'F'}, false),
			},
		),
	)
}

@(test)
test_alternation_compile :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_alternation(
			{ast.create_match_set({'A'}, false), ast.create_match_set({'B'}, false)},
		),
		{},
		bytecode.instr_split(1, 3),
		bytecode.instr_char('A', false),
		bytecode.instr_jump(4),
		bytecode.instr_char('B', false),
		bytecode.instr_match(),
	)

	describe.compiler_test(
		t,
		ast.create_alternation(
			{
				ast.create_match_set({'A'}, false),
				ast.create_match_set({'B'}, false),
				ast.create_match_set({'C'}, false),
				ast.create_match_set({'D', 'E', 'F'}, false),
			},
		),
		[][]rune{{'D', 'E', 'F'}},
		bytecode.instr_split(3, 1), // 0
		bytecode.instr_split(5, 2), // 1
		bytecode.instr_split(7, 9), // 2
		bytecode.instr_char('A', false), // 3
		bytecode.instr_jump(10), // 4
		bytecode.instr_char('B', false), // 5
		bytecode.instr_jump(10), // 6
		bytecode.instr_char('C', false), // 7
		bytecode.instr_jump(10), // 8
		bytecode.instr_set(0, false), // 9
		bytecode.instr_match(), //10
	)
}
