#!/bin/sh
#

# LDFLAGS="-L${1}/usr/lib" \

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make DESTDIR=${1} install || exit 1
