#!/bin/sh
#

./configure \
	--prefix=${1}/usr \
	|| exit 1

make && \
make install || exit 1
