#!/bin/sh
#

./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	|| exit 1

make -j2 && \
make DESTDIR=${UTILS_ROOT} install || exit 1
