#/bin/sh
#
# Copyright (C) 2022 Tamerlan Bimzhanov

PROG=./2.20

[ -f $PROG ] || { echo Couldn\'t find the program to test! >&2 ; exit 1 ; }

set_same_res() {
    local i=$2
    while [ $i -le $3 ];  do
        eval test${i}_res=\$1
        i=$((i+1))
    done
}

set_same_res "(a) (b) (c)" 1 15

test1=`echo      "a b c"                       | $PROG`
test2=`echo  -e  "a b c\n\x20\n"               | $PROG`
test3=`echo  -e  "a b c\x20\n"                 | $PROG`
test4=`echo  -e  "a b c\x20\n\n"               | $PROG`
test5=`echo  -e  "a b c\n\n"                   | $PROG`
test6=`echo  -e  "a b c\n\n\n"                 | $PROG`
test7=`echo  -e  "a b c\x20\n \n\n\n"          | $PROG`
test8=`echo  -e  "a b c\x20\x20\n"             | $PROG`
test9=`echo  -e  "a b c\x20\x20\x20\n\n"       | $PROG`
test10=`echo -e  "a b c\x20\x20\x20\x20\n\n\n" | $PROG`
test11=`echo -ne "a b c"                       | $PROG`
test12=`echo -ne "a b c\x20"                   | $PROG`
test13=`echo -ne "a b c\x20\x20"               | $PROG`
test14=`echo -ne "a b c\x20\x20\x20"           | $PROG`
test15=`echo -ne "a b c\x20\x20\x20\x20"       | $PROG`

set_same_res "`echo -e '(a) (b) (c)\n(ab) (bc) (cd) (ld)'`" 16 19

test16=`echo -e  "a b c\x20\x20\x20\x20\nab bc cd ld\n"     | $PROG`
test17=`echo -e  "a b c\x20\x20\x20\x20\nab bc cd ld\n\n"   | $PROG`
test18=`echo -ne "a b c\nab bc cd ld"                       | $PROG`
test19=`echo -ne "a b c\x20\x20\x20\x20\nab bc cd ld"       | $PROG`

test20=`echo -e "a b c\x20\x20\x20\x20
ab bc cd ld
cc ld    lkjadsf ljk lf l l\x20
 lj l l l  lkjld klj ,lk l ,,," | $PROG`
test20_res="(a) (b) (c)
(ab) (bc) (cd) (ld)
(cc) (ld) (lkjadsf) (ljk) (lf) (l) (l)
(lj) (l) (l) (l) (lkjld) (klj) (,lk) (l) (,,,)"

test21=`echo -e "\n\nidslfkj adlskfj\x20\n
       lkadsjfl kad
f sdlfkj a
  sdf\x20
j
 lk jlkj lkj lkj
     lj lk j l jl kl\x20
   kl jlkj l l\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
lj lkj lk\x20\x20" | $PROG`
test21_res=`echo -e "\n\n(idslfkj) (adlskfj)\n
(lkadsjfl) (kad)
(f) (sdlfkj) (a)
(sdf)
(j)
(lk) (jlkj) (lkj) (lkj)
(lj) (lk) (j) (l) (jl) (kl)
(kl) (jlkj) (l) (l)
(lj) (lkj) (lk)"`

test_count=21

i=1
while [ $i -le $test_count ]; do
    eval test_i=\$test$i
    eval test_i_res=\$test${i}_res
    if [ "$test_i" != "$test_i_res" ]; then
        echo TEST $i FAILED!
        echo EXPECTED: "$test_i_res"
        echo GOT: "$test_i"
    fi
    i=$((i+1))
done
