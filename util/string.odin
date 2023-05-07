package util

import uc "core:unicode"

is_alphanumeric :: proc(a: rune) -> bool {
	return uc.is_letter(a) || uc.is_number(a)
}
