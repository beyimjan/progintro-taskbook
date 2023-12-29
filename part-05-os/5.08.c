/* Copyright (C) 2023 Tamerlan Bimzhanov
 */

#define _DEFAULT_SOURCE
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

void find_files_by_name(const char *curr_dir, const char *fname)
{
  DIR *dir;
  struct dirent *entry;
  size_t curr_dname_length;

  dir = opendir(curr_dir);
  if (dir == NULL) {
    perror(curr_dir);
    return;
  }

  curr_dname_length = strlen(curr_dir);
  while ((entry = readdir(dir)) != NULL) {
    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
      continue;

    if (entry->d_type == DT_DIR) {
      size_t entry_dname_length;
      char *subdirectory;
      entry_dname_length = strlen(entry->d_name);
      subdirectory = malloc(curr_dname_length + entry_dname_length + 2);
      strcpy(subdirectory, curr_dir);
      strcat(subdirectory, "/");
      strcat(subdirectory, entry->d_name);
      find_files_by_name(subdirectory, fname);
      free(subdirectory);
    }
    else if (strcmp(entry->d_name, fname) == 0) {
      printf("%s/%s\n", curr_dir, fname);
    }
  }

  closedir(dir);
}

int main(int argc, char *argv[])
{
  if (argc < 2) {
    fprintf(stderr, "Too few arguments!\n");
    return 1;
  }

  find_files_by_name(".", argv[1]);

  return 0;
}
