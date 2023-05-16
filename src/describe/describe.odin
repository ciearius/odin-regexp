package describe

import "core:testing"
import "core:slice"

import "../ast"
import "../parser"
import "../tokenizer"
import "../bytecode"
import "../compiler"

print_tokens :: proc(t: ^testing.T, title: string, tokens: []tokenizer.Token) {
	testing.log(t, title)
	for token in tokens {
		testing.logf(t, "%v %v", token.value, token.ttype)
	}
}

tokenizer_test :: proc(t: ^testing.T, input: string, expected_tokens: ..tokenizer.Token) {
	using testing

	// TOKENIZER
	tokens := tokenizer.tokenize(input)

	if len(expected_tokens) != len(tokens) {
		fail(t)
		print_tokens(t, "want:", expected_tokens)
		print_tokens(t, "have:", tokens)
		return
	}

	for actual, i in tokens {
		expected := expected_tokens[i]
		expect_value(t, actual.ttype, expected.ttype)
		expect(t, slice.equal(actual.value, expected.value))
	}
}

parser_test :: proc(t: ^testing.T, input: []tokenizer.Token, expected_tree: ast.Node) {
	using testing

	// PARSER
	tree, err := parser.parse(input)

	expect_value(t, err, parser.ParseErr.None)

	// TODO: walk tree
}

compiler_test :: proc(
	t: ^testing.T,
	input: ast.Node,
	expected_charsets: []compiler.Charset,
	expected_code: ..bytecode.Instruction,
) {
	// COMPILER
	charsets, code := compiler.compile(input)

	for actual_charset, charsetIndex in charsets {
		testing.expect(t, slice.equal(actual_charset, expected_charsets[charsetIndex]))
	}

	ok := true

	if len(code) != len(expected_code) {
		ok = false
	} else {
		for actual_instruction, instrIndex in code {
			if actual_instruction != expected_code[instrIndex] {
				ok = false
			}
		}
	}

	if !ok {
		testing.logf(t, "Expected\n")
		for instr in expected_code {
			testing.logf(t, "%v", bytecode.to_string(instr))
		}

		testing.logf(t, "Actual")
		for instr in code {
			testing.logf(t, "%v", bytecode.to_string(instr))
		}

		testing.fail(t)
	}
}

token :: proc(tt: tokenizer.TokenType, value: ..rune) -> tokenizer.Token {
	return tokenizer.Token{tt, value, {}}
}

token_EOF :: proc() -> tokenizer.Token {
	return tokenizer.Token{ttype = .EOF}
}
