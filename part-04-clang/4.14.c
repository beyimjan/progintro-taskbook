/* Copyright (C) 2022, 2023 Tamerlan Bimzhanov
 */

#include <stdio.h>
#include <stdlib.h>

static int string_length(const char *str)
{
  int i;
  for (i = 0; str[i]; i++) {
  }
  return i;
}

static void string_copy(char *dest, const char *src)
{
  for (; *src; src++, dest++)
    *dest = *src;
  *dest = '\0';
}

static void remove_spaces(char *str)
{
  char *target;
  for (target = str;; str++, target++) {
    while (*target == ' ')
      target++;
    *str = *target;
    if (!*target)
      break;
  }
}

int main(int argc, char **argv)
{
  char *without_spaces;
  if (argc != 2) {
    fputs("Usage: 4.14 <arg>\n", stderr);
    return 1;
  }
  without_spaces = malloc(string_length(argv[1]));
  string_copy(without_spaces, argv[1]);
  remove_spaces(without_spaces);
  printf("%s\n", without_spaces);
  return 0;
}
