#!/bin/sh
#

# LDFLAGS="-L${1}/lib" \

./configure \
	--prefix=/usr \
	|| exit 1

make || exit 1
make DESTDIR=${1} install || exit 1
