#!/bin/sh
#

# LDFLAGS="-Wl,-rpath,${1}/usr/lib" \
./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	--with-gmp=${1}/usr \
	--with-mpfr=${1}/usr \
	|| exit 1

make && \
make DESTDIR=${1} install || exit 1
