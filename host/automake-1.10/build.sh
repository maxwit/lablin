#!/bin/sh
#

./configure \
	--prefix=${UTILS_ROOT}/usr \
	|| exit 1

make && \
make install || exit 1
