#!/bin/sh
#

# LDFLAGS="-Wl,-rpath,${UTILS_ROOT}/usr/lib" \
./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	--with-gmp=${UTILS_ROOT}/usr \
	--with-mpfr=${UTILS_ROOT}/usr \
	|| exit 1

make && \
make DESTDIR=${UTILS_ROOT} install || exit 1
