package vm

import "core:fmt"

to_string :: proc {
	code_to_string,
	argument_to_string,
}

code_to_string :: proc(s: Snippet) -> string {
	res := ""

	for instr, idx in s {
		res = fmt.aprintf(
			"%v%v \t %i: %s \t {{ %v }} \n",
			res,
			idx,
			instr.code,
			instr.code,
			to_string(instr.code, instr.args),
		)
	}

	return res
}

argument_to_string :: proc(code: OpCode, arg: Argument) -> string {
	switch code {

	case .CHAR:
		return fmt.aprintf("%v%v", (arg.negated ? "not " : ""), arg.char)
	case .RANGE:
		return fmt.aprintf("%v%v - %v", (arg.negated ? "not " : ""), arg.range[0], arg.range[1])
	case .SET:
		return fmt.aprintf("%vin set # %v", (arg.negated ? "not " : ""), arg.idx)
	case .SPLIT:
		return fmt.aprintf("move %v move %v", arg.split[0], arg.split[1])
	case .JUMP:
		return fmt.aprintf("move %v", arg.idx)
	case .MATCH:
		return ""
	}

	panic(fmt.aprintf("%T %v", arg, arg))
}
