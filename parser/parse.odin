package parser

import tk "../tokenizer"
import "../vm"
import "../ast"

import "core:fmt"

parse :: proc(tokens: [dynamic]tk.Token) -> ^ast.Node {
	ps := create_parserstate(tokens)

	for !eof(ps) {
		#partial switch ps.curr.ttype {

		case .Char_Lower:
			fallthrough

		case .Char_Upper:
			fallthrough

		case .Num:
			mr := ast.create_match(ps.curr.value[0])

			if ps.tree != nil {
				if t, ok := ps.tree.(^ast.Concatenation); ok {
					append(&t.nodes, cast(ast.Node)mr)
				} else {
					cc := ast.create_Concatenation(ps.tree, mr)
					ps.tree = cast(ast.Node)cc
				}
			} else {
				ps.tree = auto_cast mr
			}

			advance(ps)
			continue

		case .Plus:
			if ps.tree == nil {
				panic("+ is missing an argument")
			}

			ps.tree = ast.create_Atleastonce(ps.tree)

			advance(ps)
			continue
		}

		break
	}

	return &ps.tree
}
