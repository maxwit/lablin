#!/bin/sh
#
#

./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	|| exit 1

make && \ 
make install || exit 1

