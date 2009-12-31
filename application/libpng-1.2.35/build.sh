#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	--with-libpng-compat \
	|| exit 1

make && \
make install || exit 1

