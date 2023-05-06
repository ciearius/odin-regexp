package tokenizer

import "core:strconv"
import "core:strings"

direct_mapped := map[rune]TokenType {
	// symbols
	'|' = .Bar,
	'?' = .Q,
	'*' = .Star,
	'+' = .Plus,
	'^' = .Caret,
	'$' = .Dollar,

	// Grouping
	'(' = .Open_Paren,
	')' = .Close_Paren,
	'[' = .Open_Bracket,
	']' = .Close_Bracket,
	'{' = .Open_Brace,
	'}' = .Close_Brace,
}

Range :: struct {
	t:            TokenType,
	lower, upper: rune,
}

range_mapped := [?]Range{
	Range{.Char_Lower, 'a', 'z'},
	Range{.Char_Upper, 'A', 'Z'},
	Range{.Num, '0', '9'},
}

tokenize :: proc(s: string) -> (res: [dynamic]Token) {
	res = make([dynamic]Token)

	ts := &TokenizerState{s, &res, Pos{0, len(s)}}

	c: rune

	l: for !eof(ts) {
		c = current(ts)

		if c == '\\' {
			ts.offset += 1

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

		for r in range_mapped {
			if r.lower <= c || c <= r.upper {
				grab_rune(ts, r.t)
				continue l
			}
		}

		buf: [4]byte
		istr := strconv.itoa(buf[:], 42)

		panic(strings.concatenate({"symbol not matched ", istr}))
	}

	append(&res, Token{ttype = .EOF})

	return
}
