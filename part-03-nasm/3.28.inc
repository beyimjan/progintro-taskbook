; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%macro seq 3
  %assign n %1
  %rep %3
	dd n
    %assign n n+%2
  %endrep
%endmacro
