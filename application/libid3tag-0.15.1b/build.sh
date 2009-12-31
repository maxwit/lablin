#!/bin/sh
#
# http://maxwit.googlecode.com/
#

./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	|| exit 1

make || exit 1

make install || exit 1

