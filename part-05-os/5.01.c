/* Copyright (C) 2023 Tamerlan Bimzhanov
 */

#define _LARGEFILE64_SOURCE /* See feature_test_macros(7) */
#include <fcntl.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  int fd;
  off64_t file_size;

  if (argc < 2) {
    fprintf(stderr, "Too few arguments!\n");
    return 1;
  }

  fd = open(argv[1], O_RDONLY);
  if (fd == -1) {
    perror(argv[1]);
    return 2;
  }

  file_size = lseek64(fd, 0, SEEK_END);
  if (file_size == -1) {
    perror(argv[1]);
    return 3;
  }
  else {
    printf("File size in bytes: %ld\n", file_size);
  }

  close(fd);

  return 0;
}
