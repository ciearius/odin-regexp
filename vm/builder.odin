package vm

import "core:slice"

ConstBuilder :: struct {
	sets: [dynamic]Charset,
}

collect :: proc(i: []Instruction) -> Snippet {
	s := make(Snippet, len(i))
	s = i
	return s
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

to_program :: proc(c: ^ConstBuilder, code: []Instruction) -> ^Program {
	p := new(Program)

	defer free(c)

	p.const = to_const(c)

	return p
}

to_const :: proc(c: ^ConstBuilder) -> ^Constants {
	const := new(Constants)

	const.sets = c.sets[:]

	free(c)

	return const
}
