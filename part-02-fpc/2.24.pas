{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov }

uses
    strutils;

const
    MsgUsage = './2.24 <x> <y> <formatting>'#10#10 +
        'The program prints the result of multiplying x and y.'#10#10 +
        'The 3rd parameter specifies the number of digits after the point.'#10;

var
    x, y: real;
    n: int64;
    xcode, ycode, ncode: word;
begin
    if ParamCount <> 3 then
    begin
        write(ErrOutput, MsgUsage);
        halt(1)
    end;
    ASRealVal(ParamStr(1), x, xcode);
    ASRealVal(ParamStr(2), y, ycode);
    ASIntVal(ParamStr(3), n, ncode);
    if (xcode <> 0) or (ycode <> 0) or (ncode <> 0) then
    begin
        writeln(ErrOutput, 'Couldn''t parse your input!');
        halt(2)
    end;
    writeln(ASRealStr(x * y, n))
end.
