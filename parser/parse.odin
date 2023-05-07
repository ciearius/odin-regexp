package parser

import "core:slice"
import "core:strings"
import "core:unicode/utf8"

import tk "../tokenizer"
import "../vm"
import "../ast"
import "../util"

parse :: proc(tokens: [dynamic]tk.Token) -> (n: ast.Node, err: ParseErr) {
	ps := create_parserstate(tokens)

	exprs := make([dynamic]ast.Node)

	for !eof(ps) {
		expr := parse_expression(ps) or_return

		if !eof(ps) {
			expr = parse_quantifier(ps, expr) or_return
		}

		append(&exprs, expr)
	}

	switch len(exprs) {
	case 0:
		return
	case 1:
		return exprs[0], .None
	}

	return ast.create_concatenation(exprs[:]), .None
}

parse_expression :: proc(ps: ^ParseState) -> (res: ast.Node, err: ParseErr) {
	if res = parse_alphanum(ps) or_return; res != nil {
		return
	}

	if res = parse_grouping(ps) or_return; res != nil {
		return
	}

	if res = parse_set(ps) or_return; res != nil {
		return
	}

	if res = parse_match(ps) or_return; res != nil {
		return
	}

	// TODO: Like this?
	return nil, .Invalid
}

parse_alphanum :: proc(ps: ^ParseState) -> (n: ast.Node, err: ParseErr) {
	if ps.curr.ttype == .Alphanumeric {
		m := make([dynamic]ast.Node)

		for c, i in utf8.string_to_runes(ps.curr.value) {
			c0 := make([]rune, 1)
			c0[0] = c
			append(&m, ast.create_match_rune_set(c0))
		}

		advance(ps)
		return ast.create_concatenation(m[:]), .None
	}

	return
}

parse_grouping :: proc(ps: ^ParseState) -> (n: ast.Node, err: ParseErr) {
	if ps.curr.ttype != .Open_Paren {
		return
	}

	child := parse_expression(ps) or_return

	if eof(ps) || !matches(ps, .Close_Paren) {
		return nil, .Unclosed_Group
	}

	grouping: ast.Node = ast.create_group(child)

	return grouping, .None
}


// FIXME: endless loop!
parse_set :: proc(ps: ^ParseState) -> (n: ast.Node, err: ParseErr) {
	if !matches(ps, .Open_Bracket) {
		return
	}

	last_runes: []rune
	lower: rune
	upper: rune

	negated := false
	ranges := make([dynamic]ast.Node)
	characters := util.create_set(rune)

	is_range := false

	if matches(ps, .Caret) {
		negated = true
	}

	for !eof(ps) {
		if ps.curr.ttype == .Dash {
			if len(last_runes) == 0 {
				return nil, .InvalidRange
			}

			is_range = true
			lower = last_runes[len(last_runes) - 1]
			last_runes = last_runes[:len(last_runes) - 1]

			advance(ps)
		}

		if len(last_runes) > 0 {
			util.add_all(characters, last_runes)
			last_runes = make([]rune, 0)
			continue
		}

		if ps.curr.ttype == .Close_Bracket {
			break
		}

		if len(last_runes) == 0 && ps.curr.ttype == .Alphanumeric {
			last_runes = utf8.string_to_runes(ps.curr.value)

			if is_range {
				upper = last_runes[0]
				last_runes = last_runes[1:]
				is_range = false

				append(&ranges, ast.create_match_range(lower, upper))
				advance(ps)
				continue
			}

			advance(ps)
		}
	}

	res := make([dynamic]ast.Node)

	set_entries := util.entries(characters)

	if len(set_entries) > 0 {
		match_set := ast.create_match_rune_set(set_entries)
		append(&res, match_set)
	}

	if len(ranges) > 0 {
		match_ranges := ast.create_alternation(ranges[:])
		append(&res, match_ranges)
	}


	if !matches(ps, .Close_Bracket) {
		return nil, .UnterminatedSet
	}

	switch len(res) {
	case 0:
		return nil, .Invalid
	case 1:
		return res[0], .None
	}

	return ast.create_alternation(res[:]), .None
}

parse_match :: proc(ps: ^ParseState) -> (n: ast.Node, err: ParseErr) {

	concat := make([dynamic]^ast.Node)

	if ps.curr.ttype == .Alphanumeric {
		for r in ps.curr.value {
			m := ast.create_match_set(ps.curr.value)
			append(&concat, cast(^ast.Node)m)
		}
	}

	advance(ps)

	return cast(ast.Node)ast.create_concatenation_from_ptr(concat[:]), .None
}

parse_quantifier :: proc(ps: ^ParseState, previous: ast.Node) -> (n: ast.Node, err: ParseErr) {
	if previous == nil {
		return nil, .Invalid
	}

	if matches(ps, .Plus) {
		return ast.create_atleastonce(previous), nil
	}

	if matches(ps, .Star) {
		return ast.create_howevermany(previous), nil
	}

	if matches(ps, .Q) {
		return ast.create_optional(previous), nil
	}

	return previous, .None
}
