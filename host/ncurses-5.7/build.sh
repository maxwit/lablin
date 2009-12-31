#!/bin/sh
#
# http://code.google.com/p/maxwit/
#

CFLAGS="-fPIC" \
./configure \
	--prefix=/usr \
	--disable-shared \
	--enable-static \
	--without-cxx \
	|| exit 1

make && \
make DESTDIR=${1} install || exit 1
