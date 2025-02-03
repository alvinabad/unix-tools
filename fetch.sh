#!/bin/bash

set -e 

SKIP="
ctvl-tools
"

for r in `ls`
do
    [ -d "$r" ] || continue
    [ -d "$r/.git" ] || continue

    found=false
    for s in $SKIP
    do
        #echo "Skip: $s"
        if [ "$s" = "$r" ]; then
            found=true
            #echo "FOUND: $s $r"
            break
        fi
    done

    #echo "Found: $found"
    if [ "$found" = "true" ]; then
        continue
    fi

    echo --------------------------------------------------------------------------------
    echo REPO: $r

    (cd $r && git fetch --all)
    (cd $r && git status)
done
