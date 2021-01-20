#include "kernel.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

int main(int argc, const char *argv[])
{
	if(argc != 2) {
		return 1;
	}

	uint64_t size;
	if(!sscanf(argv[1], "%llu", &size)) {
		return 1;
	}

	int64_t *vec_long = (int64_t *)malloc(sizeof(int64_t) * size);
	if(__builtin_expect(vec_long == NULL, false)) {
		return 1;
	}
	for(int64_t i = 0; i < size; i++) {
		vec_long[i] = i;
	}
	kernel(vec_long, size);
	return 0;
}
