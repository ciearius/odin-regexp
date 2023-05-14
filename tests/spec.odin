package tests

import "core:testing"
import "core:slice"

import "../suite"

import "../ast"
import "../parser"
import "../tokenizer"
import "../bytecode"
import "../compiler"

// When everything in these patterns is supported, we can compare the results to https://github.com/mariomka/regex-benchmark
PATTERN_Email :: `[\w\.+-]+@[\w\.-]+\.[\w\.-]+`
PATTERN_URI :: `[\w]+://[^/\s?#]+[^\s?#]+(?:\?[^\s#]*)?(?:#[^\s]*)?`
PATTERN_IPv4 :: `(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])`

@(test)
test_charclass_tokenize :: proc(t: ^testing.T) {
	suite.describe_tokenizer_test(
		t,
		`\w`,
		tokenizer.Token{ttype = .Escaped, value = {'w'}},
		tokenizer.Token{ttype = .EOF},
	)

	suite.describe_tokenizer_test(
		t,
		`\W`,
		tokenizer.Token{ttype = .Escaped, value = {'W'}},
		tokenizer.Token{ttype = .EOF},
	)

	suite.describe_tokenizer_test(
		t,
		`\d`,
		tokenizer.Token{ttype = .Escaped, value = {'d'}},
		tokenizer.Token{ttype = .EOF},
	)

	suite.describe_tokenizer_test(
		t,
		`\D`,
		tokenizer.Token{ttype = .Escaped, value = {'D'}},
		tokenizer.Token{ttype = .EOF},
	)
}

@(test)
test_charclass_parse :: proc(t: ^testing.T) {
	suite.describe_parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'w'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Word, false),
	)

	suite.describe_parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'W'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Word, true),
	)

	suite.describe_parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'d'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Digit, false),
	)

	suite.describe_parser_test(
		t,
		{tokenizer.Token{ttype = .Escaped, value = {'D'}}, tokenizer.Token{ttype = .EOF}},
		ast.create_match_charclass(.Digit, true),
	)
}

@(test)
test_charclass_compile :: proc(t: ^testing.T) {
	/*

		e1|e2

		SPLIT L1, L2
	L1:	TEST e1
		Match
	L2: Test e2
		Match


		e1|e2|e3

		SPLIT L3, 1
		SPLIT L2, 1
	L1: Test e1
		Match
	L2: Test e2
		Match
	L3: Test e3
		Match
	
	*/
	suite.describe_compiler_test(
		t,
		ast.create_match_charclass(.Word, false),
		{},
		bytecode.instr_split(9, 1),
		bytecode.instr_split(6, 1),
		bytecode.instr_split(3, 1),
		bytecode.instr_range('0', '9', false), // L0
		bytecode.instr_jump(6),
		bytecode.instr_range('a', 'z', false), // L1
		bytecode.instr_jump(4),
		bytecode.instr_range('A', 'Z', false), // L2
		bytecode.instr_jump(2),
		bytecode.instr_char('_', false), // L3
		bytecode.instr_match(),
	)

	suite.describe_compiler_test(
		t,
		ast.create_match_charclass(.Digit, false),
		{},
		bytecode.instr_range('0', '9', false),
		bytecode.instr_match(),
	)

	suite.describe_compiler_test(
		t,
		ast.create_match_charclass(.Digit, true),
		{},
		bytecode.instr_range('0', '9', true),
		bytecode.instr_match(),
	)
}
