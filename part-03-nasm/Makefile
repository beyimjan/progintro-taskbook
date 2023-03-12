# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

ifndef $(OS)
OS = $(shell uname -s | tr 'a-z' 'A-Z')
endif

OS_SUPPORTED = LINUX FREEBSD
ifeq (, $(filter $(OS), $(OS_SUPPORTED)))
$(error Unknown OS, only Linux and FreeBSD are supported)
endif

AS = nasm
ASFLAGS = -g -d STUD_IO_$(OS) -d OS_$(OS) -f elf

LD = ld

BINS = 3.07 3.08 3.09 3.10 3.11 3.15 3.17 3.18 3.19 3.32 3.42
BINS2 = 3.26 3.35 3.37 3.38 3.43

all: $(BINS) $(BINS2)

clean:
	rm -f *.o $(BINS) $(BINS2)

%.o: %.asm
	$(AS) $(ASFLAGS) $<

$(BINS): $(BINS:=.o)
	$(LD) -m elf_i386 $@.o -o $@

3.26: 3.26.o itostr.o getistr.o strtoi.o putstr.o

3.35: 3.35.o strlen.o putzts.o

3.37: 3.37.o strlen.o strtoin.o itostrn.o

3.38: 3.38.o strlen.o strtoin.o itostrn.o

3.43: 3.43.o strlen.o

$(BINS2):
	$(LD) -m elf_i386 $^ -o $@
