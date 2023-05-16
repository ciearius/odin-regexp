package vm

import "../compiler"

ExecutionContext :: struct {
	ip, sp: int,
}

Stack :: struct {
	ptr:  int,
	data: []ExecutionContext,
}

stack_init :: proc(size: int) -> (s: ^Stack) {
	s = new(Stack)
	s.data = make([]ExecutionContext, size)
	s.ptr = 0
	return
}

stack_count :: proc(s: ^Stack) -> int {
	return s.ptr
}

@(optimization_mode = "speed")
stack_push :: #force_inline proc(s: ^Stack, ip, sp: int) #no_bounds_check {
	s.data[s.ptr] = ExecutionContext{ip, sp}
	s.ptr += 1
}

@(optimization_mode = "speed")
stack_pop :: #force_inline proc(s: ^Stack) -> (ip, sp: int, ok: bool) #no_bounds_check {
	if s.ptr == 0 {
		ok = false
		return
	}

	s.ptr -= 1

	ip = s.data[s.ptr].ip
	sp = s.data[s.ptr].sp
	ok = true

	return
}

stack_destroy :: proc(s: ^Stack) {
	// for el in s.data {
	// 	free(el)
	// }
	delete(s.data)
	free(s)
}
