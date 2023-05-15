package tests

import "core:testing"
import "core:slice"
import "core:fmt"

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
test_calc_b0 :: proc(t: ^testing.T) {
	actual := compiler.calc_b0(
		{
			{bytecode.instr_range('0', '9', false), bytecode.instr_jump(6)},
			{bytecode.instr_range('a', 'z', false), bytecode.instr_jump(4)},
			{bytecode.instr_range('A', 'Z', false), bytecode.instr_jump(2)},
			{bytecode.instr_char('_', false)},
		},
	)

	expected := []int{0, 2, 4, 6}

	if !slice.equal(actual, expected) {
		fmt.println("expected")
		fmt.println(expected)

		fmt.println("actual")
		fmt.println(actual)

		testing.fail(t)
	}
}

@(test)
test_generate_alternation_header :: proc(t: ^testing.T) {
	b0 := []int{0, 2, 4, 6}

	actual := compiler.generate_alternation_header(b0)

	expected := compiler.Snippet{
		bytecode.instr_split(3, 1),
		bytecode.instr_split(5, 1),
		bytecode.instr_split(7, 9),
	}

	if !slice.equal(actual, expected) {
		fmt.println("expected")
		fmt.println(bytecode.to_string(expected))

		fmt.println("actual")
		fmt.println(bytecode.to_string(actual))
		testing.fail(t)
	}

}

@(test)
test_charclass_compile :: proc(t: ^testing.T) {
	/*
		e1|e2|e3|e4

		SPLIT L1, 1		H0: 2		L1 = H0[0] + B0[0]
		SPLIT L2, 1		H0: 1		L1 = H0[1] + B0[1]
		SPLIT L3, L4	H0: 0		L1 = H0[2] + B0[2]

	L1:	Test e1			B0: 0
		JUMP done

	L2: Test e2			B0: B0(L1) + Len(L1)
		JUMP done								// B1(L2) = B0(L4) - B0(L2)

	L3: Test e3			B0: B0(L2) + len(L2)	
		JUMP done								// B1(L3) = B0(L4) - B0(L3)

	L4:	Test e4			B0: B0(L3) + len(B3)	// B1(L4) = B0(L4) - B0(L4)
	done:
	
	*/
	suite.describe_compiler_test(
		t,
		ast.create_match_charclass(.Word, false),
		{},
		bytecode.instr_split(3, 1),
		bytecode.instr_split(5, 1),
		bytecode.instr_split(7, 9),
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
