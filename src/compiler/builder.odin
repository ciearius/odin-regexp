package compiler

import "core:slice"

import "../bytecode"

Snippet :: []bytecode.Instruction
Charset :: []rune

ConstBuilder :: struct {
	sets: [dynamic]Charset,
}

add :: proc {
	add_charset,
}

add_charset :: proc(c: ^ConstBuilder, i: Charset) -> int {
	if idx, ok := lookup_charset(c, i); ok {
		return idx
	}

	append(&c.sets, i)

	return len(c.sets) - 1
}

lookup_charset :: proc(c: ^ConstBuilder, i: Charset) -> (int, bool) {
	for chset, idx in c.sets {
		if slice.equal(i, chset) {
			return idx, true
		}
	}
	return -1, false
}

init_builder :: proc() -> ^ConstBuilder {
	c := new(ConstBuilder)

	c.sets = make([dynamic]Charset)

	return c
}
