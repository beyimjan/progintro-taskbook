# Copyright (C) 2023 Tamerlan Bimzhanov

CC = gcc
CFLAGS = -g -Wall -ansi -pedantic
LDFLAGS = -lncurses

BINS = 5.01

all: $(BINS)

5.01: 5.01.c

$(BINS):
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

clean:
	rm -f *.o $(BINS)
