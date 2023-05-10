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
	stress(24)
}

stress :: proc(n: int) {
	regexp := util.build_torture_regex(n)

	fmt.println(regexp)

	tokens := tokenizer.tokenize(regexp)
	tree, err := parser.parse(tokens)

	if err != .None {
		fmt.println("Failed to parse tokens...")
	}

	prog := compiler.compile(tree)

	input := make([]rune, n)

	slice.fill(input, 'a')

	fmt.println("using n =", n)
	sw := time.now()

	r0 := vm.run(prog, input)

	fmt.println("took", time.duration_milliseconds(time.since(sw)), "ms")

	if r0 {
		fmt.println("match found!")
	} else {
		fmt.println("no match was found")
	}
}
