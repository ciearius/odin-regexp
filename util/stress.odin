package util

import "core:strings"

build_torture_regex := proc(n: int) -> string {
	return strings.concatenate({strings.repeat("a?", n), strings.repeat("a", n)})
}
