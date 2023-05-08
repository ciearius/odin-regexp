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

// @(test)
// test_parse :: proc(t: ^testing.T) {
// 	tokens := tokenizer.tokenize(`hello[a-zA-Z]+`)

// 	tree, err := parser.parse(tokens)

// 	if err != .None {
// 		fmt.println("FAILED", err)
// 	}

// 	testing.expect_value(t, err, parser.ParseErr.None)

// 	ast.prettyPrint(tree)
// }
