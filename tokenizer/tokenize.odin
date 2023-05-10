package tokenizer

import "core:unicode/utf8"
import "core:fmt"

import "../util"

direct_mapped := map[rune]TokenType {
	// symbols
	'|' = .Bar,
	'?' = .Q,
	'*' = .Star,
	'+' = .Plus,
	'^' = .Caret,
	'$' = .Dollar,
	'-' = .Dash,

	// Grouping
	'(' = .Open_Paren,
	')' = .Close_Paren,
	'[' = .Open_Bracket,
	']' = .Close_Bracket,
	'{' = .Open_Brace,
	'}' = .Close_Brace,
}

tokenize :: proc(s: string) -> (res: [dynamic]Token) {
	ts := new(TokenizerState)
	ts.input = utf8.string_to_runes(s)
	ts.res = make([dynamic]Token)
	ts.pos = Pos{0, len(s)}

	c: rune

	l: for !eof(ts) {
		c = current(ts)

		if c == '\\' {
			advance(ts)

			if eof(ts) {
				panic("unexpected eof")
			}

			grab_rune(ts, .Escaped)
			continue
		}

		if tp, ok := direct_mapped[c]; ok {
			grab_rune(ts, tp)
			continue l
		}

		if util.is_alphanumeric(c) {
			begin := ts.offset

			for !eof(ts) {
				c = current(ts)

				if !util.is_alphanumeric(c) {
					break
				}

				advance(ts)
			}

			grab(ts, .Alphanumeric, begin, ts.offset)
			continue l
		}

		panic(fmt.aprintf("failed %r ", c))
	}

	append(&ts.res, create_token(.EOF, []rune{}, Pos{}))

	return ts.res
}
