#!/bin/sh
#

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make install || exit 1
