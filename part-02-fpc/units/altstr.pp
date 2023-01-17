{ Various string handling routines

  Copyright (C) 2022, 2023 Tamerlan Bimzhanov
}

unit altstr;

interface

{ Reverses the order of characters in a string }
procedure ASReverse(var str: string);

{ Returns a string which represents the value of src }
function ASIntStr(src: int64): string;

{ Returns a string which represents the value of src.

  n -- maximum number of digits after the decimal point
}
function ASRealStr(src: real; n: byte): string;

{ ASIntVal and ASRealVal procedures convert the value represented
  in the string str to a numerical value
  and store this value in the variable res.

  If the conversion isn't successful, then the parameter err
  contains the index of the character in str which prevented the conversion.

  The string str is allowed to contain spaces in the beginning.
}
procedure ASIntVal(str: string; var res: int64; var err: word);
procedure ASRealVal(str: string; var res: real; var err: word);

implementation

uses
    chutils;

{ Changes the value of the idx parameter
  to the next non-whitespace character in the string str.

  If the string ended before a whitespace character was encountered
  then idx contains a value equal to the length of the string.
}
procedure SkipSpaces(var str: string; var idx: word);
begin
    while (idx <= length(str)) and IsWhitespace(str[idx]) do
        inc(idx)
end;

procedure ASReverse(var str: string);
var
    i, j: word;
    c: char;
begin
    for i := 1 to length(str) div 2 do
    begin
        j := length(str) - i + 1;
        c := str[i];
        str[i] := str[j];
        str[j] := c
    end
end;

function ASIntStr(src: int64): string;
var
    sign: boolean;
    res: string;
begin
    if src = 0 then
        exit('0');
    res := '';
    sign := src < 0;
    if sign then
        src := -src;
    while src <> 0 do
    begin
        res := res + chr(src mod 10 + ord('0'));
        src := src div 10
    end;
    ASReverse(res);
    if sign then
        res := '-' + res;
    exit(res)
end;

function ASRealStr(src: real; n: byte): string;
var
    digit: char;
    res: string;
    FracPart: string = '.';
begin
    res := ASIntStr(trunc(src));
    src := abs(frac(src));
    while (n > 0) and (src <> 0.0) do
    begin
        src := src * 10.0;
        digit := chr(ord('0') + trunc(src));
        if digit = '0' then
            FracPart := FracPart + '0'
        else
        begin
            res := res + FracPart + digit;
            FracPart := ''
        end;
        src := frac(src);
        dec(n)
    end;
    exit(res)
end;

procedure ASIntVal(str: string; var res: int64; var err: word);
var
    i: word = 1;
    sign: boolean;
begin
    err := 0;
    SkipSpaces(str, i);
    if (i > length(str)) or not (IsPlusOrMinus(str[i]) or IsDigit(str[i])) then
    begin
        err := i;
        exit
    end;
    res := 0;
    sign := str[i] = '-';
    if IsPlusOrMinus(str[i]) then
        inc(i);
    if i > length(str) then
    begin
        err := i;
        exit
    end;
    while i <= length(str) do
    begin
        if not IsDigit(str[i]) then
        begin
            err := i;
            exit
        end;
        res := res * 10 + ord(str[i]) - ord('0');
        inc(i)
    end;
    if sign then
        res := -res
end;

procedure ASRealVal(str: string; var res: real; var err: word);
var
    i: word = 1;
    j: real = 10.0;
    IntPart, sign: boolean;
begin
    err := 0;
    SkipSpaces(str, i);
    if (i > length(str)) or
        not ((str[i] = '.') or IsPlusOrMinus(str[i]) or IsDigit(str[i])) then
    begin
        err := i;
        exit
    end;
    res := 0.0;
    sign := str[i] = '-';
    if IsPlusOrMinus(str[i]) then
        inc(i);
    if i > length(str) then
    begin
        err := i;
        exit
    end;
    IntPart := IsDigit(str[i]);
    if str[i] = '.' then
        inc(i);
    if i > length(str) then
    begin
        err := i;
        exit
    end;
    if IntPart then
    begin
        repeat
            if not IsDigit(str[i]) then
            begin
                err := i;
                exit
            end;
            res := res * 10.0 + ord(str[i]) - ord('0');
            inc(i)
        until (i > length(str)) or (str[i] = '.');
        if (str[i] = '.') and (i <= length(str)) then
            inc(i)
    end;
    while i <= length(str) do
    begin
        if not IsDigit(str[i]) then
        begin
            err := i;
            exit
        end;
        res := res + (ord(str[i]) - ord('0')) / j;
        j := j * 10.0;
        inc(i)
    end;
    if sign then
        res := -res
end;

end.
