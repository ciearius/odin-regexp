package vm

OpCode :: enum {
	Err,

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
