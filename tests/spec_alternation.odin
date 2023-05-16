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
