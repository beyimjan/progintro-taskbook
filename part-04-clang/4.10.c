/* Copyright (C) 2022, 2023 Tamerlan Bimzhanov
 */

#include <stdio.h>

int string_length(const char *str)
{
    const char *tmp;
    tmp = str;
    while(*tmp)
        tmp++;
    return tmp - str;
}

int main(int argc, char **argv)
{
    argv++;
    while(*argv) {
        int length;
        length = string_length(*argv);
        if(length == 0 || (length >= 1 && **argv != '-'))
            printf("[%s]\n", *argv);
        argv++;
    }
    return 0;
}
