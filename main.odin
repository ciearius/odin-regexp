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
	for i in 1 ..= 30 {
		stress(i)
	}
}

stress :: proc(n: int) {
	regexp := util.build_torture_regex(n)

	fmt.println(regexp)

	tokens := tokenizer.tokenize(regexp)
	tree, err := parser.parse(tokens)

	if err != .None {
		fmt.println("Failed to parse tokens...")
	}

	const, code := compiler.compile(tree)

	input := make([]rune, n)

	slice.fill(input, 'a')

	fmt.println("using n =", n)
	sw := time.now()

	r0 := vm.run(code, const, input)

	fmt.println("took", time.duration_milliseconds(time.since(sw)), "ms")

	if r0 {
		fmt.println("match found!")
	} else {
		fmt.println("no match was found")
	}

	input[n - 1] = 'c'

	r1 := vm.run(code, const, input)

	fmt.println("took", time.duration_milliseconds(time.since(sw)), "ms")

	if r1 {
		fmt.println("match found!")
	} else {
		fmt.println("no match was found")
	}
}
