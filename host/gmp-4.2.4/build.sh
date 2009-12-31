#!/bin/sh
#

./configure \
	--prefix=/usr \
	--disable-shared \
	--enable-static \
	|| exit 1

make -j2 && \
make DESTDIR=${1} install || exit 1
