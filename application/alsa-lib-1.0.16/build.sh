#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	--disable-python \
	|| exit 1

make  || exit 1
make install || exit 1


