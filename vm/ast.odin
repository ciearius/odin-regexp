package vm

import "../ast"
import "core:slice"

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
	return create_snippet(create_instr_range(node.range[0], node.range[1], node.negated))
}

code_from_match_set :: proc(c: ^ConstBuilder, node: ^ast.Match_Set) -> Snippet {
	if len(node.cset) == 1 {
		return create_snippet(create_instr_char(node.cset[0], node.negated))
	}

	return create_snippet(create_instr_set(add(c, node.cset), node.negated))
}

code_from_concatenation :: proc(c: ^ConstBuilder, node: ^ast.Concatenation) -> Snippet {
	gen := make([dynamic]^Instruction)

	for n in node.nodes {
		append(&gen, ..code_from(c, n))
	}

	return gen[:]
}

code_from_alternation :: proc(cb: ^ConstBuilder, node: ^ast.Alternation) -> Snippet {
	blockCount := len(node.nodes)
	headerSize := blockCount - 1

	if blockCount < 2 {
		panic("cant alternate a single path")
	}

	offset := make([]int, blockCount)
	blocks := make([]Snippet, blockCount)

	sum := 0
	lastIdx := len(blocks) - 1

	for block, blockIdx in node.nodes {
		codeBlock := code_from(cb, block)
		jmpEnd := create_instr_jump(-1)

		if blockIdx == lastIdx {
			blocks[blockIdx] = codeBlock
		} else {
			blocks[blockIdx] = slice.concatenate([]Snippet{codeBlock, {jmpEnd}})
		}

		offset[blockIdx] = headerSize + sum

		sum += len(blocks[blockIdx])
	}

	sum = 1

	for rev := lastIdx; rev >= 0; rev -= 1 {
		if rev != lastIdx {
			// jmp instr
			blocks[rev][len(blocks[rev]) - 1].idx = sum
			continue
		}

		sum += len(blocks[rev])
	}

	head := make(Snippet, headerSize)

	lineIdx := 0

	for lineIdx < blockCount {
		lineOffset := headerSize - 1 - lineIdx

		if lineIdx == blockCount - 2 {
			head[lineIdx] = create_instr_split(
				offset[lineIdx] + lineOffset,
				offset[lineIdx + 1] + lineOffset,
			)

			break
		}

		head[lineIdx] = create_instr_split(offset[lineIdx] + lineOffset, 1)
		lineIdx += 1
	}

	return slice.concatenate([]Snippet{head, slice.concatenate(blocks[:])})
}

code_from_optional :: proc(c: ^ConstBuilder, node: ^ast.Optional) -> Snippet {
	panic("not implemented")
}

code_from_howevermany :: proc(c: ^ConstBuilder, node: ^ast.Howevermany) -> Snippet {
	panic("not implemented")
}

code_from_atleastonce :: proc(c: ^ConstBuilder, node: ^ast.Atleastonce) -> Snippet {
	panic("not implemented")
}
