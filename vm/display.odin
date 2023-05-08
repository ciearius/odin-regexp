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
			to_string(instr.args),
		)
	}

	return res
}

argument_to_string :: proc(arg: Argument) -> string {
	switch in arg {

	case ^Param_Char:
		p := arg.(^Param_Char)
		return fmt.aprintf("%v%v", (p.negated ? "not " : ""), p.r)
	case ^Param_Range:
		p := arg.(^Param_Range)
		return fmt.aprintf("%v%v - %v", (p.negated ? "not " : ""), p.r[0], p.r[1])
	case ^Param_Set:
		p := arg.(^Param_Set)
		return fmt.aprintf("%vin set # %v", (p.negated ? "not " : ""), p.id)
	case Param_Split:
		p := arg.(Param_Split)
		return fmt.aprintf("move %v move %v", p[0], p[1])
	case Param_Jump:
		return fmt.aprintf("move %v", arg.(Param_Jump))
	}

	panic(fmt.aprintf("%T %v", arg, arg))
}
