#!/bin/bash

unalias -a

ARCH=`uname -ms`

echo Disk Speed Test: $ARCH

case $ARCH in
    "Linux x86_64"):
        dd if=/dev/zero of=1G.txt bs=100M count=10 oflag=direct
        ;;
    "Linux armv7l"):
        dd if=/dev/zero of=1G.txt bs=100M count=10 oflag=direct
        ;;
    "Darwin x86_64"):
        dd if=/dev/zero of=1G.txt bs=100m count=10
        ;;
    "VMkernel x86_64"):
        time dd if=/dev/zero of=1G.txt bs=100M count=10
        ;;
    *):
        echo "Unknown machine."
        ;;
esac

rm -f 1G.txt
