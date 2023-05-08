package vm

import "../ast"
import "core:slice"

/*
- ^Group,

// Matching
- ^Match_Range,
- ^Match_Set,

// Collections
- ^Concatenation,
- ^Alternation,

// Quantifier
- ^Optional,
- ^Howevermany,
- ^Atleastonce,
*/

code_from :: proc(c: ^ConstBuilder, node: ast.Node) -> Snippet {

	switch in node {

	case ^ast.Group:
		return code_from_group(c, node.(^ast.Group))

	case ^ast.Match_Range:
		return code_from_match_range(c, node.(^ast.Match_Range))

	case ^ast.Match_Set:
		return code_from_match_set(c, node.(^ast.Match_Set))

	case ^ast.Concatenation:
		return code_from_concatenation(c, node.(^ast.Concatenation))

	case ^ast.Alternation:
		return code_from_alternation(c, node.(^ast.Alternation))

	case ^ast.Optional:
		return code_from_optional(c, node.(^ast.Optional))

	case ^ast.Howevermany:
		return code_from_howevermany(c, node.(^ast.Howevermany))

	case ^ast.Atleastonce:
		return code_from_atleastonce(c, node.(^ast.Atleastonce))

	}

	panic("unrecognised ast.Node")
}

code_from_group :: proc(c: ^ConstBuilder, node: ^ast.Group) -> Snippet {
	return code_from(c, node.content)
}

code_from_match_range :: proc(c: ^ConstBuilder, node: ^ast.Match_Range) -> Snippet {
	return collect({code(.RANGE, create_param_range(node.range, node.negated))})
}

code_from_match_set :: proc(c: ^ConstBuilder, node: ^ast.Match_Set) -> Snippet {
	if len(node.cset) == 1 {
		return collect({code(.CHAR, create_param_char(node.cset[0], node.negated))})
	}

	return collect({code(.SET, create_param_set(add(c, node.cset), node.negated))})
}

code_from_concatenation :: proc(c: ^ConstBuilder, node: ^ast.Concatenation) -> Snippet {
	gen := make([dynamic]Instruction)

	for n in node.nodes {
		append(&gen, ..code_from(c, n))
	}

	return gen[:]
}

code_from_alternation :: proc(c: ^ConstBuilder, node: ^ast.Alternation) -> Snippet {
	bCount := len(node.nodes)
	hSize := bCount - 1

	if bCount < 2 {
		panic("cant alternate a single path")
	}

	o0 := make([]int, bCount)
	blocks := make([dynamic]Snippet, bCount)

	idx := 0
	sum := 0

	for idx < bCount {
		blocks[idx] = code_from(c, node.nodes[idx])
		o0[idx] = hSize + sum

		sum += len(blocks[idx])
		idx += 1
	}


	head := make(Snippet, hSize)

	idx = 0
	idxO0 := hSize

	for idx < bCount {
		idxO0 = hSize - idx

		if idx == bCount - 2 {
			head[idx] = code(.SPLIT, Param_Split{o0[idx] + idxO0, o0[idx + 1] + idxO0})
			break
		}

		head[idx] = code(.SPLIT, Param_Split{o0[idx] + idxO0, 1})
	}

	r := [2]Snippet{
		head,
		slice.concatenate(blocks[:])
	}

	return slice.concatenate(r[:])
}

code_from_optional :: proc(c: ^ConstBuilder, node: ^ast.Optional) -> Snippet {
	// TODO: addressing pc?
	return nil
}

code_from_howevermany :: proc(c: ^ConstBuilder, node: ^ast.Howevermany) -> Snippet {
	return nil
}

code_from_atleastonce :: proc(c: ^ConstBuilder, node: ^ast.Atleastonce) -> Snippet {
	return nil
}
