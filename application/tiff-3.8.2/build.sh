#!/bin/sh
#
#

./configure \
	--prefix=/usr \
	--disable-cxx \
	|| exit 1

make && \
make install  || exit 1

