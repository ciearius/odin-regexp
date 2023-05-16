package util

import "core:slice"

Set :: struct($T: typeid) {
	content: map[T]struct {},
}

create_set :: proc($T: typeid) -> ^Set(T) {
	s := new(Set(T))

	s.content = make(map[T]struct {})

	return s
}

entries :: proc(s: ^Set($T)) -> []T {
	elements, err := slice.map_keys(s.content)

	if err != .None {
		panic("encountered error while collecting elements of set")
	}

	return elements
}

add :: proc(s: ^Set($T), el: T) {
	s.content[el] = struct {}
}

add_all :: proc(s: ^Set($T), elements: []T) {
	for e in elements {
		s.content[e] = struct {}{}
	}
}

includes :: proc(s: ^Set($T), el: T) -> bool {
	return el in s.content
}
