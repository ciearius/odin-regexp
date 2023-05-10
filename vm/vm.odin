package vm

import "../compiler"

VM :: struct {
	program: ^compiler.Program,
	ctx:     ^ExecutionContext,
	stack:   [dynamic]^ExecutionContext,
}

vm_fail_context :: proc(m: ^VM) {
	if len(m.stack) > 0 {
		m.ctx = pop(&m.stack)
		return
	}

	m.ctx = nil
}

vm_push_context :: proc(m: ^VM, ctx: ^ExecutionContext) {
	append(&m.stack, ctx)
}

ExecutionContext :: struct {
	input:  []rune,
	ip, sp: int,
}

create_vm :: proc(program: ^compiler.Program, initial_context: ^ExecutionContext) -> ^VM {
	mvm := new(VM)

	mvm.program = program
	mvm.stack = make([dynamic]^ExecutionContext)
	mvm.ctx = initial_context

	return mvm
}

split_context :: proc(ctx: ^ExecutionContext, rel_ip, rel_sp: int) -> ^ExecutionContext {
	nctx := new(ExecutionContext)

	nctx.input = ctx.input
	nctx.ip += rel_ip
	nctx.sp += rel_sp

	return nctx
}

create_context :: proc(input: []rune) -> ^ExecutionContext {
	ctx := new(ExecutionContext)

	ctx.input = input
	ctx.ip = 0
	ctx.sp = 0

	return ctx
}
