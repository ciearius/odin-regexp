package vm

import "../compiler"

ExecutionContext :: struct {
	ip, sp: int,
}

next_context :: #force_inline proc(stack: ^[dynamic]^ExecutionContext) -> (ip, sp: int, ok: bool) {
	if len(stack) > 0 {
		c := pop(stack)
		defer free(c)
		return c.ip, c.sp, true
	}
	return -1, -1, false
}
