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
		bytecode.instr_jump(2),
		bytecode.instr_char('B', false),
		bytecode.instr_match(),
	)
}
