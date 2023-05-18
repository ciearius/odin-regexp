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
import "../src/describe"

@(test)
test_vm :: proc(t: ^testing.T) {
	// `a[a-zA-Z]`

	describe.vm_test(
		t,
		{
			bytecode.instr_char('a', false),
			bytecode.instr_split(2, 4),
			bytecode.instr_range('a', 'z', false),
			bytecode.instr_jump(5),
			bytecode.instr_range('A', 'Z', false),
			bytecode.instr_match(),
		},
		{},
		{'a', 'B'},
		true,
	)
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
