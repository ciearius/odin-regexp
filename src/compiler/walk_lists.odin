package compiler

import "core:slice"

import "../ast"
import "../bytecode"


code_from_concatenation :: proc(c: ^ConstBuilder, node: ^ast.Concatenation) -> Snippet {
	gen := make([dynamic]bytecode.Instruction)

	for n in node.nodes {
		append(&gen, ..code_from(c, n))
	}

	return gen[:]
}

calc_b0 :: #force_inline proc(blocks: []Snippet) -> []int {
	b0 := make([]int, len(blocks))

	for block, idx in blocks {
		if idx == 0 {
			continue
		}
		b0[idx] = b0[idx - 1] + len(blocks[idx - 1])
	}

	return b0
}

generate_alternation_header :: #force_inline proc(b0: []int) -> Snippet {
	bCount := len(b0)
	hCount := bCount - 1

	code := make(Snippet, hCount)

	for i in 0 ..< hCount {
		index := b0[i] + hCount
		code[i] = bytecode.instr_split(index, 1)
	}

	last_header := hCount - 1
	code[last_header].split[1] = b0[hCount] + hCount

	return code
}

code_from_alternation :: proc(cb: ^ConstBuilder, node: ^ast.Alternation) -> Snippet {
	blockCount := len(node.nodes)
	hCount := blockCount - 1

	if blockCount < 2 {
		panic("cant alternate a single path")
	}

	blocks := make([]Snippet, blockCount)

	for rawBlock, i in node.nodes {
		code := code_from(cb, rawBlock)

		// Append jump instruction to all but the last block
		if blockCount - 1 != i {
			code = append_instr(code, bytecode.instr_jump(-1))
		}

		blocks[i] = code
	}

	b0 := calc_b0(blocks)

	header := generate_alternation_header(b0)

	last_block_idx := len(b0) - 1
	full_offset := b0[last_block_idx]
	block: Snippet

	for i in 0 ..< last_block_idx {
		block = blocks[i]

		block[len(block) - 1].idx = full_offset - b0[i]
	}

	return slice.concatenate([]Snippet{header, slice.concatenate(blocks)})
}
