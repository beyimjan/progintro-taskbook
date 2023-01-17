# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

CC = gcc
CFLAGS = -g -Wall -ansi -pedantic

BINS = 4.10 4.14

all: $(BINS)

4.10: 4.10.c

4.14: 4.14.c

$(BINS):
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o $(BINS)
