; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%macro pcall 1-*
  %rep %0-1
    %rotate -1
	push %1
  %endrep
  %rotate -1
	call %1
  %if %0 >= 2
	add esp, (%0-1)*4
  %endif
%endmacro
