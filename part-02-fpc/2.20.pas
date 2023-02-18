{ Copyright (C) 2022, 2023 Tamerlan Bimzhanov }

uses
    chutils, wparser;

var
    parser: TWordParser;
    FirstWord: boolean;
begin
    WPStart(parser);
    repeat
        if parser.start then
            FirstWord := true;
        WPStep(parser);
        if parser.state = WP_SOW then
        begin
            if FirstWord then
                write('(')
            else
                write(' (')
        end;
        if parser.state in [WP_SOW, WP_MOW] then
            write(parser.c);
        if parser.state in [WP_EOW, WP_EOW_EOL, WP_EOW_EOF] then
        begin
            write(')');
            FirstWord := false
        end;
        if (parser.state in [WP_EOL, WP_EOW_EOL, WP_EOW_EOF]) or
            ((parser.state = WP_EOF) and
                not parser.start and (parser.c <> #10)) then
        begin
            writeln
        end
    until parser.state in [WP_EOF, WP_EOW_EOF]
end.
