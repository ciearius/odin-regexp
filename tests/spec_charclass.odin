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
test_charclass_tokenize :: proc(t: ^testing.T) {
	describe.tokenizer_test(
		t,
		`\w`,
		tokenizer.Token{ttype = .Escaped, value = {'w'}},
		tokenizer.Token{ttype = .EOF},
	)

	describe.tokenizer_test(
		t,
		`\W`,
		tokenizer.Token{ttype = .Escaped, value = {'W'}},
		tokenizer.Token{ttype = .EOF},
	)

	describe.tokenizer_test(
		t,
		`\d`,
		tokenizer.Token{ttype = .Escaped, value = {'d'}},
		tokenizer.Token{ttype = .EOF},
	)

	describe.tokenizer_test(
		t,
		`\D`,
		tokenizer.Token{ttype = .Escaped, value = {'D'}},
		tokenizer.Token{ttype = .EOF},
	)
}

@(test)
test_charclass_parse :: proc(t: ^testing.T) {
	describe.parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'w'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Word, false),
	)

	describe.parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'W'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Word, true),
	)

	describe.parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'d'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Digit, false),
	)

	describe.parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'D'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Digit, true),
	)
}

@(test)
test_charclass_compile :: proc(t: ^testing.T) {
	describe.compiler_test(
		t,
		ast.create_match_charclass(.Word, false),
		{},
		bytecode.instr_split(3, 1),
		bytecode.instr_split(5, 1),
		bytecode.instr_split(7, 9),
		bytecode.instr_range('0', '9', false),
		bytecode.instr_jump(6),
		bytecode.instr_range('a', 'z', false),
		bytecode.instr_jump(4),
		bytecode.instr_range('A', 'Z', false),
		bytecode.instr_jump(2),
		bytecode.instr_char('_', false),
		bytecode.instr_match(),
	)

	describe.compiler_test(
		t,
		ast.create_match_charclass(.Digit, false),
		{},
		bytecode.instr_range('0', '9', false),
		bytecode.instr_match(),
	)

	describe.compiler_test(
		t,
		ast.create_match_charclass(.Digit, true),
		{},
		bytecode.instr_range('0', '9', true),
		bytecode.instr_match(),
	)
}
