#!/bin/bash

set -e 

for r in `ls`
do
    [ -d "$r" ] || continue

    echo --------------------------------------------------------------------------------
    echo $r

    (cd $r && git fetch origin)
    (cd $r && git status)
done
