{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov
}

unit lstr_list;

interface

uses
    lstr;

type
    TSListIPtr = ^TSListItem;
    TSListItem = record
        str: TLongString;
        next: TSListIPtr;
    end;
    TStrList = record
        first, last: TSListIPtr;
    end;

procedure SLCreate(var list: TStrList);
procedure SLDelete(var list: TStrList);

procedure SLPut(var list: TStrList; str: TLongString);

function SLIsEmpty(var list: TStrList): boolean;

implementation

procedure SLCreate(var list: TStrList);
begin
    list.first := nil;
    list.last := nil
end;

procedure SLDelete(var list: TStrList);
var
    tmp: TSListIPtr;
begin
    while list.first <> nil do
    begin
        tmp := list.first;
        list.first := list.first^.next;
        LSDelete(tmp^.str);
        dispose(tmp)
    end;
    list.last := nil
end;

procedure SLPut(var list: TStrList; str: TLongString);
var
    tmp: TSListIPtr;
begin
    new(tmp);
    LSCreate(tmp^.str);
    LSCat(tmp^.str, str);
    tmp^.next := nil;
    if list.first = nil then
    begin
        list.first := tmp;
        list.last := tmp
    end
    else
    begin
        list.last^.next := tmp;
        list.last := tmp
    end
end;

function SLIsEmpty(var list: TStrList): boolean;
begin
    exit(list.first = nil)
end;

end.
