# Copyright (C) 2022 Tamerlan Bimzhanov

FPC = fpc
EXE = -g

BINS = 2.20

%: %.pas
	$(FPC) $(EXE) -Fuunits/ $<

all: $(BINS)

clean:
	find . \( -name '*.o' -o -name '*.ppu' \) -delete
	rm -f $(BINS)
