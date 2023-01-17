# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

FPC = fpc
EXE = -g

BINS = 2.20 2.24 2.43

%: %.pas
	$(FPC) $(EXE) -Fuunits/ $<

all: $(BINS)

clean:
	find . \( -name '*.o' -o -name '*.ppu' \) -delete
	rm -f $(BINS)
