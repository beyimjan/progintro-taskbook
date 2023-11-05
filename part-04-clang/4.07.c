/* Copyright (C) 2022, 2023 Tamerlan Bimzhanov
 */

#include "4.07.h"

int count_spaces(const char *str)
{
  int res = 0;
  for (; *str; str++)
    if (*str == ' ')
      res++;
  return res;
}
