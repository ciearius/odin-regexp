package graph

Set :: struct($T: typeid) {
	s: map[T]uint,
}

get :: proc(myset: ^Set($T), key: T) -> (uint, bool) {
	return myset.s[key]
}

init_set :: proc($T: typeid) -> ^Set(T) {
	mymap := make(map[T]uint)
	myset := new(Set(T))

	myset.s = mymap

	return myset
}

to_set_from_dynamic_array :: proc(a: [dynamic]$T) -> ^Set(T) {
	myset := init_set(T)
	count: uint = 0

	for v in a {
		if v in myset.s {
			continue
		}
		myset.s[v] = count
		count += 1
	}

	return myset
}

to_set_from_slice :: proc(a: []$T) -> ^Set(T) {
	myset := init_set(T)
	count: uint = 0

	for v in a {
		if v in myset.s {
			continue
		}
		myset.s[v] = count
		count += 1
	}

	return myset
}

to_set_from_array :: proc(a: [$b]$T) -> ^Set(T) {
	myset := init_set(T)
	count: uint = 0

	for v in a {
		if v in myset.s {
			continue
		}
		myset.s[v] = count
		count += 1
	}

	return myset
}

to_set :: proc {
	to_set_from_array,
	to_set_from_slice,
	to_set_from_dynamic_array,
}

destroy_set :: proc(myset: ^Set($T)) {
	delete(myset.s)
	free(myset)
}
