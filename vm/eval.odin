package vm

import "core:slice"

import b "../bytecode"
import c "../compiler"

@(optimization_mode = "speed")
run :: proc(code: []b.Instruction, sets: []c.Charset, input: []rune) -> bool #no_bounds_check {
	stack := make([dynamic]^ExecutionContext, 0, len(code))

	ok := true
	ip := 0
	sp := 0

	crune: rune
	instr: b.Instruction

	for ok {
		crune = 0
		instr = {}

		if sp < len(input) {
			crune = input[sp]
		}
		if ip < len(code) {
			instr = code[ip]
		}

		// fmt.println(b.to_string(instr))

		if .JUMP == instr.code {
			ip += instr.idx
			continue
		}

		if .SPLIT == instr.code {
			a := new(ExecutionContext)
			a^ = ExecutionContext{ip + instr.split[1], sp}

			append(&stack, a)

			ip += instr.split[0]
			continue
		}

		if .CHAR == instr.code {
			if instr.char == crune {
				ip += 1
				sp += 1
				continue
			}

			ip, sp, ok = next_context(&stack)
			continue
		}

		if .SET == instr.code {
			if _, ok := slice.binary_search(sets[instr.idx], crune); ok {
				ip += 1
				sp += 1
				continue
			}

			ip, sp, ok = next_context(&stack)
			continue
		}

		if .RANGE == instr.code {
			if instr.range[0] <= crune && crune <= instr.range[1] {
				ip += 1
				sp += 1
				continue
			}

			ip, sp, ok = next_context(&stack)
			continue
		}

		if .MATCH == instr.code {
			return true
		}

		break
	}

	return false
}
