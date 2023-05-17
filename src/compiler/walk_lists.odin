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

code_from_alternation :: proc(cb: ^ConstBuilder, node: ^ast.Alternation) -> Snippet {
	n := len(node.nodes)

	// check state
	assert(n >= 2, "cant have a an alternation with less than two paths")

	// compile children
	blocks := get_blocks(cb, node.nodes)

	// pointer to end
	end := slice.reduce(blocks, 2 * (n - 1), proc(prev: int, curr: Snippet) -> int {
		return prev + len(curr)
	})

	offset_sum := n - 1

	// adding jump to end
	for block, b in blocks {
		offset_by(&blocks[b], offset_sum)

		if b == len(node.nodes) - 1 {
			break
		}

		blocks[b] = append_instr(block, bytecode.instr_jump(end))
		offset_sum += (len(block) + 1)
	}

	header := make(Snippet, n - 1)

	blockPointers := make([]int, n)

	blockPointers[0] = n - 1

	for i in 1 ..< n {
		blockPointers[i] = len(blocks[i - 1]) + blockPointers[i - 1]
	}

	for i in 0 ..< n - 2 {
		header[i] = bytecode.instr_split(blockPointers[i], i + 1)
	}

	header[n - 2] = bytecode.instr_split(blockPointers[n - 2], blockPointers[n - 1])

	return slice.concatenate([]Snippet{header, slice.concatenate(blocks)})
}

get_blocks :: proc(cb: ^ConstBuilder, nodes: []ast.Node) -> (blocks: []Snippet) {
	blocks = make([]Snippet, len(nodes))

	for n, i in nodes {
		blocks[i] = code_from(cb, n)
	}

	return
}

offset_by :: proc(s: ^Snippet, value: int) {
	for i, idx in s {
		#partial switch i.code {
		case .JUMP:
			s[idx].idx += value
		case .SPLIT:
			s[idx].split[0] += value
			s[idx].split[1] += value
		}
	}
}
