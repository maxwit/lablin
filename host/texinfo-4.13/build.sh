#!/bin/sh
#

# LDFLAGS="-L${UTILS_ROOT}/usr/lib" \

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make DESTDIR=${UTILS_ROOT} install || exit 1
