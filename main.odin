package main

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:time"

import "./tokenizer"
import "./parser"
import "./ast"
import "./vm"
import "./compiler"
import "./bytecode"
import "./util"

main :: proc() {
	iterations := 25
	start := time.now()

	for i in 0 ..= iterations {
		stress(20)
	}

	took := time.since(start)
	fmt.printf("%v for %v iterations\n", time.duration_milliseconds(took), iterations)
	fmt.println(took / auto_cast iterations)
}

stress :: proc(n: int) {
	exp := util.build_torture_regex(n)

	defer delete(exp)

	tokens := tokenizer.tokenize(exp)

	defer delete(tokens)

	tree, err := parser.parse(tokens)

	if err != .None {
		panic("failed to parse")
	}

	defer ast.destroy_node(tree)

	const, code := compiler.compile(tree)

	input0_failing := util.build_input(n - 1, 'a')
	input1_matching := util.build_input(n, 'a')

	defer delete(input0_failing)
	defer delete(input1_matching)

	match0 := vm.run(code, const, input0_failing)
	assert(!match0, "expect too short string not to match")

	match1 := vm.run(code, const, input1_matching)
	assert(match1, "expect match")
}
