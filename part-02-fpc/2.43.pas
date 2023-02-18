{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov }

uses
    wparser, lstr, lstr_list;

type
    TLineIPtr = ^TLineItem;
    TLineItem = record
        ch: TLSItemPtr;
        next: TLineIPtr;
    end;
    TLine = record
        first, last: TLineIPtr;
    end;

procedure LineCreate(var line: TLine; var list: TStrList);
var
    item: TLineIPtr;
    tmp: TSListIPtr;
begin
    line.first := nil;
    line.last := nil;

    tmp := list.first;
    while tmp <> nil do
    begin
        new(item);
        item^.ch := tmp^.str.first;
        item^.next := nil;
        if line.first = nil then
        begin
            line.first := item;
            line.last := item
        end
        else
        begin
            line.last^.next := item;
            line.last := item
        end;
        tmp := tmp^.next
    end
end;

procedure LineDelete(var line: TLine);
var
    tmp: TLineIPtr;
begin
    while line.first <> nil do
    begin
        tmp := line.first;
        line.first := line.first^.next;
        dispose(tmp)
    end;
    line.last := nil
end;

{ Prints a list of strings vertically.

  For example, for the words "Happy New Year to everyone" will be printed:
  HNYte
  aeeov
  pwa e
  p r r
  y   y
      o
      n
      e
}
procedure SLPrintVer(var list: TStrList);
var
    data, buffer: TLongString;
    line: TLine;
    tmp: TLineIPtr;
begin
    if SLIsEmpty(list) then
        exit;
    LineCreate(line, list);
    LSCreate(data);
    LSCreate(buffer);
    while true do
    begin
        tmp := line.first;
        while tmp <> nil do
        begin
            if tmp^.ch = nil then
                LSCat(buffer, ' ')
            else
            begin
                LSCat(data, buffer);
                LSDelete(buffer);
                LSCat(data, tmp^.ch^.c);
                tmp^.ch := tmp^.ch^.next
            end;
            tmp := tmp^.next
        end;
        LSDelete(buffer);
        if LSIsEmpty(data) then
            break
        else
        begin
            LSCat(data, #10);
            LSPrint(data);
            LSDelete(data)
        end
    end;
    LineDelete(line)
end;

var
    str: TLongString;
    list: TStrList;
    parser: TWordParser;
begin
    SLCreate(list);
    LSCreate(str);

    WPStart(parser);
    repeat
        WPStep(parser);
        if parser.state in [WP_SOW, WP_MOW] then
            LSCat(str, parser.c);
        if parser.state in [WP_EOW, WP_EOW_EOL, WP_EOW_EOF] then
        begin
            SLPut(list, str);
            LSDelete(str)
        end;
        if parser.state in [WP_EOL, WP_EOF, WP_EOW_EOL, WP_EOW_EOF] then
        begin
            SLPrintVer(list);
            SLDelete(list)
        end
    until parser.state in [WP_EOF, WP_EOW_EOF]
end.
