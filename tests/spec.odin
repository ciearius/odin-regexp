package tests

import "core:testing"
import "core:slice"


import "../ast"
import "../parser"
import "../tokenizer"
import "../bytecode"
import "../compiler"

// When everything in these patterns is supported, we can compare the results to https://github.com/mariomka/regex-benchmark
PATTERN_Email :: `[\w\.+-]+@[\w\.-]+\.[\w\.-]+`
PATTERN_URI :: `[\w]+://[^/\s?#]+[^\s?#]+(?:\?[^\s#]*)?(?:#[^\s]*)?`
PATTERN_IPv4 :: `(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])`

// TODO: setup tests with `setup_test`

setup_test :: proc(
	t: ^testing.T,
	input: string,
	expected_tokens: []tokenizer.Token,
	expected_tree: ast.Node,
	expected_charsets: []compiler.Charset,
	expected_code: compiler.Snippet,
) {
	using testing

	// TOKENIZER
	tokens := tokenizer.tokenize(input)

	for actual, i in tokens {
		expected := expected_tokens[i]
		expect_value(t, actual.ttype, expected.ttype)
		expect(t, slice.equal(actual.value, expected.value))
	}

	// PARSER
	tree, err := parser.parse(tokens)

	expect_value(t, err, parser.ParseErr.None)

	// COMPILER
	charsets, code := compiler.compile(tree)

	for actual_charset, charsetIndex in charsets {
		expect(t, slice.equal(actual_charset, expected_charsets[charsetIndex]))
	}

	for actual_instruction, instrIndex in code {
		expect_value(t, actual_instruction, expected_code[instrIndex])
	}
}
