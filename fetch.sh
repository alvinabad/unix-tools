#!/bin/bash

set -e 

REPOS="
adafruit-feather-esp32
adafruit-feather-m0
adafruit-qt-py-m0
adafruit-trinket5
adafruit-trinket-m0
adafruit-itsybitsy-rp2040
adafruit-qtpy-rp2040

arduino-nano-33-iot
arduino-nano-rp2040-connect
c_kr
esp32-computepi
esp32-devkit-v4
gopl
heltec_wifi_kit_32
raspberrypi-pico-rp2040
"

cmd=$1

for r in `ls`
do
    [ -d "$r" ] || continue

    echo --------------------------------------------------------------------------------
    echo $r

    (cd $r && git fetch origin)
    (cd $r && git status)

    if [ "$cmd" = 'p' ]; then
        (cd $r && git push origin)
    fi
done
