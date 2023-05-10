package vm

import "core:fmt"
import "core:slice"

import "../bytecode"
import "../compiler"

run :: proc(prog: ^compiler.Program, input: []rune) -> bool {
	m := create_vm(prog, create_context(input))

	for m.ctx != nil {
		instr := m.program.code[m.ctx.ip]
		crune := m.ctx.input[m.ctx.sp]

		fmt.println(crune, bytecode.to_string(instr))

		#partial switch instr.code {

		case .MATCH:
			return true

		case .SPLIT:
			vm_push_context(m, split_context(m.ctx, instr.split[1], 0))
			m.ctx.ip += instr.split[0]
			continue

		case .JUMP:
			m.ctx.ip += instr.idx
			continue

		case .SET:
			if _, ok := slice.binary_search(m.program.const.sets[instr.idx], crune); ok {
				m.ctx.ip += 1
				continue
			}

			vm_fail_context(m)
			continue

		case .RANGE:
			if instr.range[0] <= crune && crune <= instr.range[1] {
				m.ctx.ip += 1
				continue
			}

			vm_fail_context(m)
			continue

		case .CHAR:
			if instr.char == crune {
				m.ctx.ip += 1
				continue
			}

			vm_fail_context(m)
			continue

		}

		break
	}

	return false
}
