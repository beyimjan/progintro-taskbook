#/bin/sh
#
# Copyright (C) 2022, 2023 Tamerlan Bimzhanov

start=`date +%s`

# if an argument contains spaces or special characters,
# $@ will treat it as a single entity,
# while $* will break it into separate words
eval "$@"
finish=`date +%s`

printf "Elapsed time: %s seconds\n" $((finish-start))
