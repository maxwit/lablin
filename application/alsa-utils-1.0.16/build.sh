#!/bin/sh
#
# http://maxwit.googlecode.com
#


./configure --prefix=/usr || exit 1

make || exit 1

if [ ! -e alsamixer/alsamixer ]; then
	echo "Fail to build alsa-utils!"
	exit 1
fi

for exe in alsactl alsamixer aplay amixer; do
	make -C ${exe} install-exec || exit 1
done

