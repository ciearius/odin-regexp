package vm

import "core:slice"

import b "../bytecode"
import c "../compiler"

run :: proc(code: []b.Instruction, sets: []c.Charset, input: []rune) -> bool #no_bounds_check {
	stack := make([dynamic]ExecutionContext, 0, len(code))

	ctx := ExecutionContext {
		ip = 0,
		sp = 0,
	}

	crune: rune
	instr: b.Instruction

	for !ctx.failed {
		crune = 0
		instr = {}

		if len(input) > ctx.sp {
			crune = input[ctx.sp]
		}
		if len(code) > ctx.ip {
			instr = code[ctx.ip]
		}

		if .JUMP == instr.code {
			ctx.ip += instr.idx
			continue
		}

		if .SPLIT == instr.code {
			append(&stack, split_context(&ctx, instr.split[1], 0))
			ctx.ip += instr.split[0]
			continue
		}

		if .CHAR == instr.code {
			if instr.char == crune {
				ctx.ip += 1
				ctx.sp += 1
				continue
			}

			ctx = next_context(&stack)
			continue
		}

		if .SET == instr.code {
			if _, ok := slice.binary_search(sets[instr.idx], crune); ok {
				ctx.ip += 1
				ctx.sp += 1
				continue
			}

			ctx = next_context(&stack)
			continue
		}

		if .RANGE == instr.code {
			if instr.range[0] <= crune && crune <= instr.range[1] {
				ctx.ip += 1
				ctx.sp += 1
				continue
			}

			ctx = next_context(&stack)
			continue
		}

		if .MATCH == instr.code {
			return true
		}

		break
	}

	return false
}
