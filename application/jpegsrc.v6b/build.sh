#!/bin/sh
#
#

ARCH=`uname -m`

# sed -i 's/i\[3456\]86)/i\[3456\]86 | x86_64*)/' config.sub

sed -i "s/ltconfig\(.*\)/ltconfig\1 ${ARCH}-linux/" configure

./configure \
	--prefix=/usr \
	--enable-shared \
	--enable-static \
	|| exit 1

sed -i 's/\(^mandir.*=.*prefix)\)/\1\/share/' Makefile

make && \
make install  || exit 1

