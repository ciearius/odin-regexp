package vm

import "../compiler"

ExecutionContext :: struct {
	ip, sp: int,
	failed: bool,
}

split_context :: proc(ctx: ^ExecutionContext, rel_ip, rel_sp: int) -> ExecutionContext {
	return ExecutionContext{ip = ctx.ip + rel_ip, sp = ctx.sp + rel_sp}
}

next_context :: proc(stack: ^[dynamic]ExecutionContext) -> ExecutionContext {
	if len(stack) > 0 {
		return pop(stack)
	}
	return {failed = true}
}
