package tests

import "core:testing"
import "core:fmt"
import "core:slice"


import "../src/tokenizer"
import "../src/parser"
import "../src/ast"
import "../src/vm"
import "../src/compiler"
import "../src/bytecode"
import "../src/util"

@(test)
test_vm :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`a[a-zA-Z]`)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	const, code := compiler.compile(tree)

	r := vm.run(code, const, []rune{'a', 'A'})

	testing.expect_value(t, r, true)
}

@(test)
test_optional :: proc(t: ^testing.T) {
	// FIXME: segvault when using "a?a(b)?"
	tokens := tokenizer.tokenize(`a?a[b-e]?`)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	const, code := compiler.compile(tree)

	fmt.println(bytecode.to_string(code))

	r0 := vm.run(code, const, []rune{'a', 'b', 'b', 'a', 'a'})

	testing.expect_value(t, r0, true)

	r1 := vm.run(code, const, []rune{'b', 'b', 'a', 'a', 'a'})

	testing.expect_value(t, r1, false)
}

@(test)
test_build_input :: proc(t: ^testing.T) {
	c := util.build_input(10, 'a')

	fmt.println(c, len(c))

	testing.expect_value(t, len(c), 10)

	for i := 0; i < 10; i += 1 {
		testing.expect_value(t, c[i], 'a')
	}
}

// @(test)
// test_optional_stress :: proc(t: ^testing.T) {
// 	exp := util.build_torture_regex(5)

// 	fmt.println("Stressing with:", exp)

// 	tokens := tokenizer.tokenize(exp)

// 	tree, err := parser.parse(tokens)

// 	testing.expect_value(t, err, parser.ParseErr.None)

// 	const, code := compiler.compile(tree)

// 	// fmt.println("Shouldn't match")
// 	result0 := vm.run(code, const, []rune{'a', 'a', 'a', 'a'})
// 	// fmt.println("It does...?!" if result0 else "As expected!")
// 	testing.expect_value(t, result0, false)

// 	// fmt.println("Should match")
// 	result1 := vm.run(code, const, []rune{'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'})

// 	// fmt.println("As expected!" if result1 else "It doesn't...?!")
// 	testing.expect_value(t, result1, true)
// }
