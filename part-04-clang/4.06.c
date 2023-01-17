/* Copyright (C) 2022, 2023 Tamerlan Bimzhanov
 */

#include "4.06.h"

int put_sum(int *a, int*b, int*c)
{
    *a = *a + *b + *c;
    *b = *a;
    *c = *a;
    return *a;
}
