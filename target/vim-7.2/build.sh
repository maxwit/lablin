#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	|| exit 1

make || exit
make install || exit


