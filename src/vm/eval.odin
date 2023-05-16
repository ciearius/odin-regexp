package vm

import "core:slice"

import b "../bytecode"
import c "../compiler"

@(optimization_mode = "speed")
run :: proc(code: []b.Instruction, sets: []c.Charset, input: []rune) -> bool #no_bounds_check {
	stack := stack_init(len(code))

	defer stack_destroy(stack)

	ip, sp := 0, 0
	ok, drop_ctx := true, false

	for ok {
		instr := code[ip]
		curr := input[sp]

		switch instr.code {
		case .JUMP:
			ip += instr.idx

		case .SPLIT:
			stack_push(stack, ip + instr.split[1], sp)
			ip += instr.split[0]

		case .CHAR:
			if instr.char == curr {
				ip += 1
				sp += 1
				continue
			}
			drop_ctx = true

		case .SET:
			if _, ok := slice.binary_search(sets[instr.idx], curr); ok {
				ip += 1
				sp += 1
				continue
			}
			drop_ctx = true

		case .RANGE:
			if instr.range[0] <= curr && curr <= instr.range[1] {
				ip += 1
				sp += 1
				continue
			}
			drop_ctx = true

		case .MATCH:
			return true

		case .Err:
			break

		}

		if drop_ctx {
			ip, sp, ok = stack_pop(stack)
			drop_ctx = false
		}
	}

	return false
}
