#/bin/bash
#
# Copyright (C) 2023 Tamerlan Bimzhanov

prog=./3.15

[ -f $prog ] || { echo Couldn\'t find the program to test! >&2 ; exit 1 ; }

while read -r question && read -r answer ; do
    result=$(echo -e "$question" | $prog)
    if [ "$result" != "$(echo -e "$answer")" ]; then
        echo -e TEST "'$question'" FAILED!
        echo -e EXPECTED: "'$answer'"
        echo GOT: "'$result'"
        echo "----------------------------------------"
    fi
done << EOF
    ()
    YES
    (
    NO
    )
    NO
    (((((
    NO
    ())(
    NO
    (())
    YES
    ))((
    NO
    (()()())
    YES
    ()((())())
    YES
    )(
    NO
    ()()
    YES
    )(
    NO
    ((()))
    YES
    ()()()
    YES
    ()(()())
    YES
    ((()))
    YES
    (()()))
    NO
    ((()()))
    YES
    (()))
    NO
    ()(()))
    NO
    ((()))
    YES
    (((())))
    YES
    ((((((((((((((((((
    NO
    ((((((((((((((((((()))
    NO
    ()(())((())()()())
    YES
    ((()))
    YES
    ()(((())))
    YES
    (((((((((((((((((((((((())))))))))))))))))))))))))
    NO
    (()((()()((((()(())))((((())()(()))(((())))))(((()))(())))((()))))(()()()((()())())())))
    YES
    (((((((((((((((()))))))))))))))))
    NO
    (()(())((()))((((())))))(((()))))
    NO
EOF
