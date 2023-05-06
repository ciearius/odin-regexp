package tests

import "core:testing"
import "core:fmt"

import "../tokenizer"
import "../parser"
import "../ast"

// @(test)
// test_tokenize :: proc(t: ^testing.T) {
// 	for tok in tokenizer.tokenize(`^\[\[(a-zA-Z0-9)+\]\]`) {
// 		fmt.println(tok.value, tok.ttype)
// 	}
// }

@(test)
test_parse :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`he+llo+`)

	tree := parser.parse(tokens)

	ast.prettyPrint(tree)
}
