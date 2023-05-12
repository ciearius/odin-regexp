package main

import "core:fmt"
import "core:time"

import "./tokenizer"
import "./parser"
import "./ast"
import "./vm"
import "./compiler"
import "./util"

main :: proc() {
	nLen := 20
	iterations := 25

	track_valid := new(time.Stopwatch)
	track_invalid := new(time.Stopwatch)

	for i in 0 ..= iterations {
		exp := util.build_torture_regex(nLen)
		defer delete(exp)

		// Checking valid input
		input0 := util.build_input(nLen, 'a')

		time.stopwatch_start(track_valid)
		res0 := execute(exp, input0)
		time.stopwatch_stop(track_valid)

		assert(res0, "expected a match!")
		delete(input0)

		// Checking non-matching input
		input1 := util.build_input(nLen - 1, 'a')

		time.stopwatch_start(track_invalid)
		res1 := execute(exp, input0)
		time.stopwatch_stop(track_invalid)

		assert(!res1, "expected no match!")
		delete(input1)
	}

	total_valid := time.stopwatch_duration(track_valid^)
	total_invalid := time.stopwatch_duration(track_invalid^)

	fmt.printf("Time tracked %#v\n", time.duration_milliseconds(total_valid + total_invalid))

	per_valid: time.Duration = total_valid / auto_cast iterations
	per_invalid: time.Duration = total_invalid / auto_cast iterations

	fmt.printf("valid match\t%v\n", time.duration_milliseconds(per_valid))
	fmt.printf("invalid match\t%v\n", time.duration_milliseconds(per_invalid))

	free(track_valid)
	free(track_invalid)
}

execute :: proc(exp: string, input: []rune) -> bool {
	tokens := tokenizer.tokenize(exp)

	defer delete(tokens)

	tree, err := parser.parse(tokens)

	if err != .None {
		panic("failed to parse")
	}

	defer ast.destroy_node(tree)

	const, code := compiler.compile(tree)

	return vm.run(code, const, input)
}
