package util

import "core:strings"
import "core:slice"

build_torture_regex := proc(n: int) -> string {
	return strings.concatenate({strings.repeat("a?", n), strings.repeat("a", n)})
}

build_input :: proc(n: int, r: rune) -> []rune {
	res := make([]rune, n)

	slice.fill(res, r)

	return res
}
