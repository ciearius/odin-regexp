package util

deref :: proc(arraylike: $T/[]^$E) -> []E {
	me := make([]E, len(arraylike))

	for el, idx in arraylike {
		me[idx] = el^
	}

	return me
}
