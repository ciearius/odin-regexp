package tests

import "core:testing"
import "core:fmt"

import tokenizer "../tokenizer"

// @(test)
// test_tokenize :: proc(t: ^testing.T) {
// 	for tok in tokenizer.tokenize(`^\[\[(a-zA-Z0-9)+\]\]`) {
// 		fmt.println(tok.value, tok.ttype)
// 	}
// }

@(test)
test_tokenize :: proc(t: ^testing.T) {
	for tok in tokenizer.tokenize(`hello+`) {
		fmt.println(tok.value, tok.ttype)
	}
}
