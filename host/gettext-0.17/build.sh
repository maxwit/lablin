#!/bin/sh
#

# LDFLAGS="-L${UTILS_ROOT}/lib" \

./configure \
	--prefix=/usr \
	|| exit 1

make || exit 1
make DESTDIR=${UTILS_ROOT} install || exit 1
