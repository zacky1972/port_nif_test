#include "kernel.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#define N 600000

int main()
{
	int64_t *vec_long = (int64_t *)malloc(sizeof(int64_t) * N);
	if(__builtin_expect(vec_long == NULL, false)) {
		return 1;
	}
	for(int64_t i = 0; i < N; i++) {
		vec_long[i] = i;
	}
	kernel(vec_long, N);
	return 0;
}