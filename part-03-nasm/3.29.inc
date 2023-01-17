; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%macro switch 1-*
		cmp eax, 1
		jb %%else
		cmp eax, %0
		ja %%else

		jmp %%atable

%%table		dd %1
  %rep %0-1
    %rotate 1
		dd %1
  %endrep

%%atable:	jmp [%%table+eax-1]

%%else:		nop
%endmacro
