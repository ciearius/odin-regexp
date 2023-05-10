package compiler

import "core:slice"

import "../ast"
import "../bytecode"


code_from_concatenation :: proc(c: ^ConstBuilder, node: ^ast.Concatenation) -> Snippet {
	gen := make([dynamic]^bytecode.Instruction)

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
		jmpEnd := bytecode.instr_jump(-1)

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
			head[lineIdx] = bytecode.instr_split(
				offset[lineIdx] + lineOffset,
				offset[lineIdx + 1] + lineOffset,
			)

			break
		}

		head[lineIdx] = bytecode.instr_split(offset[lineIdx] + lineOffset, 1)
		lineIdx += 1
	}

	return slice.concatenate([]Snippet{head, slice.concatenate(blocks[:])})
}
