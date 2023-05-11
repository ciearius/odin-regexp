package vm

import "../compiler"

ExecutionContext :: struct {
	ip, sp: int,
}

create_context :: proc(ip, sp: int) -> ExecutionContext {
	return ExecutionContext{ip, sp}
}

next_context :: proc(stack: ^[dynamic]ExecutionContext) -> (ip, sp: int, ok: bool) {
	if len(stack) > 0 {
		c := pop(stack)
		return c.ip, c.sp, true
	}
	return -1, -1, false
}
