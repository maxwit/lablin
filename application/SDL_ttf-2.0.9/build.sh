#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	|| exit 1

make  && \
make install  || exit 1

