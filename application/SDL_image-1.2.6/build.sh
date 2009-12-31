#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--enable-sdltest  \
	|| exit 1

make  && \
make install  || exit 1


