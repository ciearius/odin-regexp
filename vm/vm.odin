package vm

VM :: struct {
	program: ^Program,
	input:   string,
	ip, sp:  int,
}
