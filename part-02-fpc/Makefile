# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

FPC = fpc
EXE = -g

BINS = 2.20 2.24 2.43

%: %.pas
	$(FPC) $(EXE) $<

all: $(BINS)

clean:
	rm -f *.o *.ppu $(BINS)
