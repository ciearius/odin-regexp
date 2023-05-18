package describe

import "core:testing"
import "core:slice"
import "core:fmt"
import "core:runtime"

import "../ast"
import "../parser"
import "../tokenizer"
import "../bytecode"
import "../compiler"
import "../vm"

print_tokens :: proc(
	t: ^testing.T,
	title: string,
	tokens: []tokenizer.Token,
	loc := #caller_location,
) {
	testing.log(t, title)

	for token in tokens {
		testing.log(t, tokenizer.to_string(token))
	}
}

summary :: proc(t: ^testing.T, loc := #caller_location) {
	testing.log(t, ("[+]" if !testing.failed(t) else "[-]"), loc.procedure)
}

tokenizer_test :: proc(
	t: ^testing.T,
	input: string,
	expected_tokens: ..tokenizer.Token,
	loc := #caller_location,
) {
	using testing

	tokens := tokenizer.tokenize(input)

	defer if testing.failed(t) {
		print_tokens(t, "want:", expected_tokens)
		print_tokens(t, "have:", tokens)
	}

	if !testing.expect_value(t, len(tokens), len(expected_tokens), loc) {
		return
	}

	for actual, i in tokens {
		expected := expected_tokens[i]
		ok :=
			expect_value(t, actual.ttype, expected.ttype, loc) &&
			expect(t, slice.equal(actual.value, expected.value), "", loc)

		if !ok {
			testing.log(t, "mismatch at:", i)
			testing.log(t, tokenizer.to_string(actual))
			testing.log(t, tokenizer.to_string(expected))
		}
	}
}

parser_test :: proc(
	t: ^testing.T,
	input: []tokenizer.Token,
	expected_tree: ast.Node,
	loc := #caller_location,
) {
	using testing

	tree, err := parser.parse(input)

	expect_value(t, err, parser.ParseErr.None, loc)

	// expect_value(t, tree, expected_tree)
	// TODO: walk tree
}

compiler_test :: proc(
	t: ^testing.T,
	input: ast.Node,
	expected_charsets: []compiler.Charset,
	expected_code: ..bytecode.Instruction,
	loc := #caller_location,
) {
	charsets, code := compiler.compile(input)

	defer if testing.failed(t) {
		testing.logf(t, "Expected")
		for instr in expected_code {
			testing.logf(t, "%v", bytecode.to_string(instr))
		}

		testing.logf(t, "Actual")
		for instr in code {
			testing.logf(t, "%v", bytecode.to_string(instr))
		}
	}

	if !testing.expect_value(t, len(charsets), len(expected_charsets)) {
		testing.log(t, "Expected", expected_charsets, loc)
		testing.log(t, "Actual", charsets, loc)
		return
	}

	for actual_charset, charsetIndex in charsets {
		testing.expect(
			t,
			slice.equal(actual_charset, expected_charsets[charsetIndex]),
			"Charsets differ",
			loc,
		)
	}

	if !testing.expect_value(t, len(code), len(expected_code), loc) {
		return
	}

	for actual_instruction, instrIndex in code {
		testing.expect_value(t, actual_instruction, expected_code[instrIndex], loc)
	}
}

vm_test :: proc(
	t: ^testing.T,
	input_code: []bytecode.Instruction,
	input_sets: []compiler.Charset,
	input_str: []rune,
	expected_outcome: bool,
	loc := #caller_location,
) {
	actual := vm.run(input_code, input_sets, input_str)

	testing.expect_value(t, actual, expected_outcome, loc)
}

token :: proc(tt: tokenizer.TokenType, value: ..rune) -> tokenizer.Token {
	return tokenizer.Token{tt, value, {}}
}

token_EOF :: proc() -> tokenizer.Token {
	return tokenizer.Token{ttype = .EOF}
}
