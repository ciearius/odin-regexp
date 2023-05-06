package ast

import "core:fmt"
import "core:strings"

prettyPrint :: proc(n: ^Node, depth: int = 0) {
	d := strings.repeat("\t", depth)

	switch in n {

	case ^Match_Rune:
		fmt.println(d, "Match_Rune {")
		fmt.println(d, "\t", n.(^Match_Rune).r)
		fmt.println(d, "}")

	case ^Concatenation:
		fmt.println(d, "Concatenation {")
		cc := n.(^Concatenation)
		for _, i in cc.nodes {
			prettyPrint(&cc.nodes[i], depth + 1)
		}
		fmt.println(d, "}")

	case ^Alternation:
		alt := n.(^Alternation)
		fmt.println(d, "Alternation {")
		prettyPrint(&alt.a, depth + 1)
		prettyPrint(&alt.b, depth + 1)
		fmt.println(d, "}")

	case ^Optional:
		fmt.println(d, "Optional {")
		prettyPrint(&n.(^Optional).a, depth + 1)
		fmt.println(d, "}")

	case ^Howevermany:
		fmt.println(d, "Howevermany {")
		prettyPrint(&n.(^Howevermany).a, depth + 1)
		fmt.println(d, "}")


	case ^Atleastonce:
		fmt.println(d, "Atleastonce {")
		prettyPrint(&n.(^Atleastonce).a, depth + 1)
		fmt.println(d, "}")

	}
}
