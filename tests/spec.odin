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

// When everything in these patterns is supported, we can compare the results to https://github.com/mariomka/regex-benchmark
PATTERN_Email :: `[\w\.+-]+@[\w\.-]+\.[\w\.-]+`
PATTERN_URI :: `[\w]+://[^/\s?#]+[^\s?#]+(?:\?[^\s#]*)?(?:#[^\s]*)?`
PATTERN_IPv4 :: `(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])`

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
