#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>
#include <stdlib.h>

#define LOOP_VECTORIZE_WIDTH 8

void kernel(int64_t *vec_long, size_t vec_l);

#endif // KERNEL_H
