#/bin/bash
#
# Copyright (C) 2022 Tamerlan Bimzhanov

prog=./2.20

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
    a b c\x20
    (a) (b) (c)
    a b c \x20
    (a) (b) (c)
    a b c  \x20
    (a) (b) (c)
    a b c   \x20
    (a) (b) (c)
    a b c\n\x20
    (a) (b) (c)
    a b c \n \n\n
    (a) (b) (c)
    a b c\n\n
    (a) (b) (c)
    a b c    \n\n
    (a) (b) (c)
    a b c\n
    (a) (b) (c)
    a b c \n
    (a) (b) (c)
    a b c   \n
    (a) (b) (c)
    a b c
    (a) (b) (c)
    a b c    \nab bc cd ld
    (a) (b) (c)\n(ab) (bc) (cd) (ld)
    a b c    \nab bc cd ld\n
    (a) (b) (c)\n(ab) (bc) (cd) (ld)
    a b c\nab bc cd ld
    (a) (b) (c)\n(ab) (bc) (cd) (ld)
    a b c    \nab bc cd ld
    (a) (b) (c)\n(ab) (bc) (cd) (ld)
    a b c    \nab bc cd ld\ncc ld    lkjadsf ljk lf l l\n lj l l l  lkjld klj ,lk l ,,,
    (a) (b) (c)\n(ab) (bc) (cd) (ld)\n(cc) (ld) (lkjadsf) (ljk) (lf) (l) (l)\n(lj) (l) (l) (l) (lkjld) (klj) (,lk) (l) (,,,)
    \n\nidslfkj adlskfj \n\n       lkadsjfl kad\nf sdlfkj a\n  sdf \nj\n lk jlkj lkj lkj\n     lj lk j l jl kl \n   kl jlkj l l            \nlj lkj lk \x20
    \n\n(idslfkj) (adlskfj)\n\n(lkadsjfl) (kad)\n(f) (sdlfkj) (a)\n(sdf)\n(j)\n(lk) (jlkj) (lkj) (lkj)\n(lj) (lk) (j) (l) (jl) (kl)\n(kl) (jlkj) (l) (l)\n(lj) (lkj) (lk)
EOF
