package ast

import "core:fmt"
import "core:strings"

prettyPrint :: proc(n: Node, depth: int = 0) {
	d := strings.repeat("\t", depth)

	switch in n {

	case ^Group:
		fmt.println(d, "Group {")
		prettyPrint(n.(^Group).content, depth + 1)
		fmt.println(d, "}")

	case ^Match_Set:
		fmt.println(d, "Match_Set {")
		fmt.println(d, "\t", n.(^Match_Set).cset)
		fmt.println(d, "}")

	case ^Match_Range:
		m := n.(^Match_Range)
		fmt.println(d, "^Match_Range {")
		fmt.println(d, ("\tnot" if m.negated else "\t"), m.range)
		fmt.println(d, "}")

	case ^Concatenation:
		prettyPrint_NodeCollection("Concatenation", n.(^Concatenation), depth)

	case ^Alternation:
		prettyPrint_NodeCollection("Alternation", n.(^Alternation), depth)

	case ^Optional:
		prettyPrint_Quantifier("Optional", n.(^Optional), depth)

	case ^Howevermany:
		prettyPrint_Quantifier("Howevermany", n.(^Howevermany), depth)

	case ^Atleastonce:
		prettyPrint_Quantifier("Atleastonce", n.(^Atleastonce), depth)
	}
}

prettyPrint_Quantifier :: proc(name: string, n: ^Quantifier, depth: int = 0) {
	d := strings.repeat("\t", depth)

	fmt.println(d, name, "{")
	prettyPrint(n.content, depth + 1)
	fmt.println(d, "}")
}

prettyPrint_NodeCollection :: proc(name: string, n: ^NodeCollection, depth: int = 0) {
	d := strings.repeat("\t", depth)

	fmt.println(d, name, "{")

	for _, i in n.nodes {
		prettyPrint(n.nodes[i], depth + 1)
	}

	fmt.println(d, "}")
}
