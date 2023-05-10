package bytecode

import "core:fmt"

to_string :: proc {
	argument_to_string,
	instr_to_string,
	code_to_string,
}

instr_to_string :: proc(instr: ^Instruction) -> string {
	return fmt.aprintf("%i: %s \t {{ %v }}", instr.code, instr.code, to_string(instr.code, instr))
}

code_to_string :: proc(s: []^Instruction) -> string {
	res := ""

	for instr, idx in s {
		res = fmt.aprintf("%v%v \t %v \n", res, idx, instr_to_string(instr))
	}

	return res
}

argument_to_string :: proc(code: OpCode, instr: ^Instruction) -> string {
	switch code {

	case .CHAR:
		return fmt.aprintf("%v%v", (instr.negated ? "not " : ""), instr.char)
	case .RANGE:
		return fmt.aprintf(
			"%v%v - %v",
			(instr.negated ? "not " : ""),
			instr.range[0],
			instr.range[1],
		)
	case .SET:
		return fmt.aprintf("%vin set # %v", (instr.negated ? "not " : ""), instr.idx)
	case .SPLIT:
		return fmt.aprintf("move %v move %v", instr.split[0], instr.split[1])
	case .JUMP:
		return fmt.aprintf("move %v", instr.idx)
	case .MATCH:
		return ""
	case .Err:
		return ""
	}

	panic(fmt.aprintf("%v %T %v", code, instr, instr))
}
