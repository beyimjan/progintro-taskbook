{ Copyright (C) 2022 Tamerlan Bimzhanov
}

unit wparser;

interface

type
    TWPState = (
        WP_NONE,
        WP_EOL,     { end of line }
        WP_EOF,     { end of file }
        WP_SOW,     { start of word }
        WP_MOW,     { middle of word }
        WP_EOW,     { end of word }
        WP_EOW_EOL, { end of word and end of line }
        WP_EOW_EOF  { end of word and end of file }
    );
    TWordParser = record
        start: boolean;
        pc: char;
        c: char;
        state: TWPState;
    end;

{ Work with the parser must be started by calling this procedure }
procedure WPStart(var parser: TWordParser);

{ The parser reads one character at a time into parser.c from stdin,
  and marks the beginning, middle, and end of "words".

  A "word" is a sequence of characters that is not a space, tab, or line feed.

  If after calling this procedure parser.state contains
  WP_EOF, WP_EOW_EOF work with the parser must be completed.
}
procedure WPStep(var parser: TWordParser);

implementation

uses
    chutils;

procedure WPStart(var parser: TWordParser);
begin
    parser.start := true
end;

procedure WPStep(var parser: TWordParser);
begin
    if eof then
    begin
        if not parser.start and not IsTabOrSpace(parser.c) then
            parser.state := WP_EOW_EOF
        else
            parser.state := WP_EOF;
        exit
    end;
    parser.state := WP_NONE;
    parser.pc := parser.c;
    read(parser.c);
    if parser.c = #10 then { next line is new }
    begin
        if not parser.start and not IsTabOrSpace(parser.pc) then
            parser.state := WP_EOW_EOL
        else
            parser.state := WP_EOL;
        parser.start := true
    end
    else if parser.start then { new line }
    begin
        if not IsTabOrSpace(parser.c) then { word starts }
            parser.state := WP_SOW;
        parser.start := false
    end
    else { in the middle of the line }
    begin
        if IsTabOrSpace(parser.pc) then
        begin
            if not IsTabOrSpace(parser.c) then { word starts }
                parser.state := WP_SOW
        end
        else begin
            if IsTabOrSpace(parser.c) then { word ends }
                parser.state := WP_EOW
            else { in the middle of the word }
                parser.state := WP_MOW
        end
    end
end;

end.
