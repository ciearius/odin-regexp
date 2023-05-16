package parser

ParseErr :: enum {
	None,
	Invalid,
	InvalidRange,
	UnexpectedToken,
	UnexpectedEOF,
	Unclosed_Group,
	UnterminatedSet,
}
