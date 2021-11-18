#!/bin/bash

unalias -a

rm -f 1G.txt
sync

ARCH=`uname -ms`

echo Disk Speed Test: $ARCH

ds1() {
    echo "Writing..."
    dd if=/dev/zero of=1G.txt bs=100M count=10 oflag=direct iflag=fullblock,nocache
    sync

    echo "Reading..."
    echo "xxxx" >> 1G.txt
    dd if=1G.txt of=/dev/null bs=100M count=10 iflag=fullblock,nocache
    sync
}

case $ARCH in
    "Linux x86_64"):
        ds1
        ;;
    "Linux armv7l"):
        echo "Writing..."
        dd if=/dev/zero of=1G.txt bs=100M count=10 oflag=direct
        sync

        echo "Reading..."
        dd if=1G.txt of=/dev/null bs=100M count=10 iflag=direct
        sync
        ;;
    "Darwin x86_64"):
        echo "Writing..."
        dd if=/dev/zero of=1G.txt bs=100m count=10
        sync

        echo "Reading..."
        dd if=/dev/zero of=1G.txt bs=100m count=10
        sync
        ;;
    "VMkernel x86_64"):
        echo "Writing..."
        time dd if=/dev/zero of=1G.txt bs=100M count=10
        sync

        echo "Reading..."
        time dd of=/dev/null if=1G.txt bs=100M count=10
        sync
        ;;
    *):
        echo "Unknown machine."
        ;;
esac

rm -f 1G.txt
sync
