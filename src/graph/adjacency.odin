package graph

import "core:slice"

Adjacency :: struct {
	mtrix:  [][]bool,
	labels: ^Set(int),
}

create_adjacency :: proc(labels: []int) -> Adjacency {
	dim := len(labels)
	mtx := make([][]bool, dim)

	for _, i in mtx {
		mtx[i] = make([]bool, dim)
	}

	return Adjacency{mtx, to_set(labels)}
}

destroy_adjacency :: proc(a: ^Adjacency) {
	for m in a.mtrix {
		delete(m)
	}
	delete(a.mtrix)
	destroy_set(a.labels)
	free(a)
}
