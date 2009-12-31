#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	|| exit 1

make || exit
make install || exit
