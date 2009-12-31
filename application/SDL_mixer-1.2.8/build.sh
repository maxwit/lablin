#!/bin/sh
#
# http://code.google.com/p/maxwit/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	|| exit 1

make && \
make install  || exit 1

#--disable-music-mp3  \

