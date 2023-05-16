package ast

import "core:slice"

Node :: union {
	^Group,

	// Matching
	^Match_Range,
	^Match_Set,
	^Match_CharClass,

	// Collections
	^Concatenation,
	^Alternation,

	// Quantifier
	^Optional,
	^Howevermany,
	^Atleastonce,
}
