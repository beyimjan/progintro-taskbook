# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

CC = gcc
CFLAGS = -g -Wall -ansi -pedantic
LDFLAGS = -lncurses

BINS = 4.10 4.14 4.22

all: $(BINS)

4.10: 4.10.c

4.14: 4.14.c

4.22: 4.22.c

$(BINS):
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

clean:
	rm -f *.o $(BINS)
