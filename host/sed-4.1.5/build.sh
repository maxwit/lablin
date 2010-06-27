#!/bin/sh
#

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make DESTDIR=${UTILS_ROOT} install || exit 1
