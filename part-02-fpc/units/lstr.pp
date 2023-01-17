{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov
}

unit lstr;

interface

type
    TLSItemPtr = ^TLSItem;
    TLSItem = record
        c: char;
        next: TLSItemPtr;
    end;
    TLongString = record
        first, last: TLSItemPtr;
    end;

procedure LSCreate(var str: TLongString);
procedure LSDelete(var str: TLongString);

procedure LSCat(var dst: TLongString; src: char);
procedure LSCat(var dst: TLongString; src: TLongString);

function LSIsEmpty(var str: TLongString): boolean;

procedure LSPrint(var str: TLongString);

implementation

procedure LSCreate(var str: TLongString);
begin
    str.first := nil;
    str.last := nil
end;

procedure LSDelete(var str: TLongString);
var
    tmp: TLSItemPtr;
begin
    while str.first <> nil do
    begin
        tmp := str.first;
        str.first := str.first^.next;
        dispose(tmp)
    end;
    str.last := nil
end;

procedure LSCat(var dst: TLongString; src: char);
var
    tmp: TLSItemPtr;
begin
    new(tmp);
    tmp^.c := src;
    tmp^.next := nil;
    if dst.first = nil then
    begin
        dst.first := tmp;
        dst.last := tmp
    end
    else
    begin
        dst.last^.next := tmp;
        dst.last := tmp
    end
end;

procedure LSCat(var dst: TLongString; src: TLongString);
var
    tmp: TLSItemPtr;
begin
    tmp := src.first;
    while tmp <> nil do
    begin
        LSCat(dst, tmp^.c);
        tmp := tmp^.next
    end
end;

function LSIsEmpty(var str: TLongString): boolean;
begin
    exit(str.first = nil)
end;

procedure LSPrint(var str: TLongString);
var
    tmp: TLSItemPtr;
begin
    tmp := str.first;
    while tmp <> nil do
    begin
        write(tmp^.c);
        tmp := tmp^.next
    end
end;

end.
