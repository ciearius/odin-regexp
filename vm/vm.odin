package vm

OpCode :: enum {
	CHAR, // c
	MATCH,
	JUMP, // x
	SPLIT, // x, y
}

OpParam_Char :: rune

OpParam_Jump :: int

OpParam_Split :: [2]int

OpParam :: union {
	OpParam_Char,
	OpParam_Jump,
	OpParam_Split,
}

Op :: struct {
	opcode: OpCode,
	param:  OpParam,
}

Program :: struct {
	ops: [dynamic]Op,
}

run :: proc(p: ^Program, str: string) -> bool {
	pc := 0
	sp := 0

	return eval(p, str, &pc, &sp)
}

eval :: proc(p: ^Program, str: string, pc, sp: ^int) -> bool {
	c := p.ops[pc^]
	for {
		switch c.opcode {
		case .MATCH:
			return true

		case .CHAR:
			if rune(str[sp^]) != c.param.(OpParam_Char) {
				return false
			}
			pc^ += 1
			sp^ += 1
			continue

		case .JUMP:
			pc^ = c.param.(OpParam_Jump)
			continue

		case .SPLIT:
			param := c.param.(OpParam_Split)
			if eval(p, str, &param[0], sp) {
				return true
			}
			pc^ = param[1]
			continue
		}
	}

	return false
}
