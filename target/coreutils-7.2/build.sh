#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--exec-prefix=/ \
	--sysconfdir=/etc \
	|| exit 1

make || exit
make install || exit
