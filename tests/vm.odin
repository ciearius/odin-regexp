package tests

import "core:testing"
import "core:fmt"
import "core:slice"


import "../tokenizer"
import "../parser"
import "../ast"
import "../vm"
import "../compiler"
import "../bytecode"
import "../util"

@(test)
test_vm :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`a[a-zA-Z]`)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	prog := compiler.compile(tree)

	r := vm.run(prog, []rune{'a', 'A'})

	testing.expect_value(t, r, true)
}

@(test)
test_optional :: proc(t: ^testing.T) {
	tokens := tokenizer.tokenize(`a?a?a?a?`)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	prog := compiler.compile(tree)

	r0 := vm.run(prog, []rune{'a', 'a', 'a', 'a', 'a'})

	testing.expect(t, r0, "match")

	fmt.println(r0)

	r1 := vm.run(prog, []rune{'a', 'a', 'a', 'a'})

	fmt.println(r1)

	testing.expect(t, r0, "no match")
}

@(test)
test_optional_stress :: proc(t: ^testing.T) {
	exp := util.build_torture_regex(10)

	fmt.println("Stressing with:", exp)

	tokens := tokenizer.tokenize(exp)

	tree, err := parser.parse(tokens)

	testing.expect_value(t, err, parser.ParseErr.None)

	prog := compiler.compile(tree)

	fmt.println("Shouldn't match")
	result0 := vm.run(prog, []rune{'a', 'a', 'a', 'a', 'a'})
	fmt.println("It does...?!" if result0 else "As expected!")
	testing.expect_value(t, result0, false)

	fmt.println("Should match")
	result1 := vm.run(prog, []rune{'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'})
	fmt.println("As expected!" if result1 else "It doesn't...?!")
	testing.expect_value(t, result1, true)

}
