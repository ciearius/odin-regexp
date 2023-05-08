package vm

OpCode :: enum {
	// matching
	CHAR,
	SET,
	RANGE,

	// control flow
	JUMP,
	SPLIT, // x, y

	// results
	MATCH,
}
