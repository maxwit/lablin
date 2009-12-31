#!/bin/sh
#
# http://code.google.com/p/maxwit/
#

./configure \
	--prefix=/usr \
	|| exit 1

make || exit 1
make install || exit 1
