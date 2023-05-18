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
test_optional :: proc(t: ^testing.T) {
	// TODO: check if the following is still up-to-date -> FIXME: segvault when using "a?a(b)?"

	// tokens := tokenizer.tokenize(`a?a[b-e]?`)

	describe.tokenizer_test(
		t,
		`a?a[b-e]?`,
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Q, '?'),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Open_Bracket, '['),
		describe.token(.Alphanumeric, 'b'),
		describe.token(.Dash, '-'),
		describe.token(.Alphanumeric, 'e'),
		describe.token(.Close_Bracket, ']'),
		describe.token(.Q, '?'),
		describe.token_EOF(),
	)

	tree := ast.create_concatenation(
		{
			ast.create_optional(ast.create_match_set({'a'}, false)),
			ast.create_match_set({'a'}, false),
			ast.create_optional(ast.create_match_range('b', 'e')),
		},
	)

	describe.parser_test(
		t,
		{
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Q, '?'),
			describe.token(.Alphanumeric, 'a'),
			describe.token(.Open_Bracket, '['),
			describe.token(.Alphanumeric, 'b'),
			describe.token(.Dash, '-'),
			describe.token(.Alphanumeric, 'e'),
			describe.token(.Close_Bracket, ']'),
			describe.token(.Q, '?'),
			describe.token_EOF(),
		},
		tree,
	)

	code := []bytecode.Instruction{
		bytecode.instr_split(1, 2),
		bytecode.instr_char('a', false),
		bytecode.instr_char('a', false),
		bytecode.instr_split(4, 5),
		bytecode.instr_range('b', 'e', false),
		bytecode.instr_match(),
	}

	describe.compiler_test(t, tree, {}, ..code)

	describe.vm_test(t, code, {}, {'a', 'b', 'b', 'a', 'a'}, true)

	describe.vm_test(t, code, {}, {'b', 'b', 'a', 'a', 'a'}, false)
}
