package tests

import "core:testing"

import "../src/describe"
import "../src/parser"


@(test)
test_tokenize_0 :: proc(t: ^testing.T) {
	expr := `hello[a-zA-Z]+`

	describe.tokenizer_test(
		t,
		expr,
		describe.token(.Alphanumeric, 'h', 'e', 'l', 'l', 'o'),
		describe.token(.Open_Bracket, '['),
		describe.token(.Alphanumeric, 'a'),
		describe.token(.Dash, '-'),
		describe.token(.Alphanumeric, 'z', 'A'),
		describe.token(.Dash, '-'),
		describe.token(.Alphanumeric, 'Z'),
		describe.token(.Close_Bracket, ']'),
		describe.token(.Plus, '+'),
		describe.token(.EOF),
	)
}
