#!/bin/bash

set -e

unalias -a

usage() {
    cat <<EOF
Usage:
    $(basename $0) dir
EOF
    exit 1
}

cleanup() {
    if [ -f "$TEST_FILE" ]; then
        rm -f "$TEST_FILE"
    fi
}

dir=$1

[ -d "$dir" ] || usage

TEST_FILE="${dir}/1G.txt"

trap cleanup EXIT

sync

ARCH=`uname -ms`

echo Disk Speed Test: $ARCH $TEST_FILE

rm -f $TEST_FILE

ds1() {
    echo "Writing..."
    dd if=/dev/zero of=${TEST_FILE} bs=100M count=10 oflag=direct iflag=fullblock,nocache
    sync

    echo "Reading..."
    openssl rand -base64 20 >> ${TEST_FILE}
    dd if=${TEST_FILE} of=/dev/null bs=100M count=10 iflag=fullblock,nocache
    sync
}

ds_rpi() {
    echo "Writing..."
    dd if=/dev/zero of=${TEST_FILE} bs=100M count=10 oflag=direct
    sync

    echo "Reading..."
    openssl rand -base64 20 >> ${TEST_FILE}
    dd if=${TEST_FILE} of=/dev/null bs=100M count=10 iflag=direct
    sync
}

case $ARCH in
    "Linux x86_64"):
        ds1
        ;;
    "Linux aarch64"):
        ds_rpi
        ;;
    "Linux armv7l"):
        ds_rpi
        ;;
    "Darwin x86_64"):
        echo "Writing..."
        dd if=/dev/zero of=${TEST_FILE} bs=100m count=10
        sync

        echo "Reading..."
        openssl rand -base64 20 >> ${TEST_FILE}
        dd if=/dev/zero of=${TEST_FILE} bs=100m count=10
        sync
        ;;
    "VMkernel x86_64"):
        echo "Writing..."
        time dd if=/dev/zero of=${TEST_FILE} bs=100M count=10
        sync

        echo "Reading..."
        time dd of=/dev/null if=${TEST_FILE} bs=100M count=10
        sync
        ;;
    *):
        echo "Unknown machine."
        ;;
esac

rm -f ${TEST_FILE}
sync
