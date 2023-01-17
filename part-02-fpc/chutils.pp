{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov
}

unit chutils;

interface

{ Returns true if character is a digit from 0 to 9, otherwise false }
function IsDigit(c: char): boolean;

{ Returns true if character is #9, #10 or ' ', otherwise false }
function IsWhitespace(c: char): boolean;

{ Returns true if character is #9 or ' ', otherwise false }
function IsTabOrSpace(c: char): boolean;

{ Returns true if character is '+' or '-', otherwise false }
function IsPlusOrMinus(c: char): boolean;

implementation

function IsDigit(c: char): boolean;
begin
    exit((c >= '0') and (c <= '9'))
end;

function IsWhitespace(c: char): boolean;
begin
    exit((c = #9) or (c = #10) or (c = ' '))
end;

function IsTabOrSpace(c: char): boolean;
begin
    exit((c = #9) or (c = ' '))
end;

function IsPlusOrMinus(c: char): boolean;
begin
    exit((c = '+') or (c = '-'))
end;

end.
