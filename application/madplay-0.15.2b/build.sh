#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	|| exit 1

make || exit 1

make install || exit 1

