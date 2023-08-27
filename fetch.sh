#!/bin/bash

set -e 

for r in `ls`
do
    [ -d "$r" ] || continue
    [ -d "$r/.git" ] || continue

    echo --------------------------------------------------------------------------------
    echo REPO: $r

    (cd $r && git fetch --all)
    (cd $r && git status)
done
