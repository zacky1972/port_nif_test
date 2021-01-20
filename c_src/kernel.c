#include "kernel.h"

void 
kernel(int64_t *vec_long, size_t vec_l)
{
#pragma clang loop vectorize_width(LOOP_VECTORIZE_WIDTH)
  for(size_t i = 0; i < vec_l; i++) {
    vec_long[i] = (((((vec_long[i])+1)*22)*vec_long[i])%6700417);
  }
}
