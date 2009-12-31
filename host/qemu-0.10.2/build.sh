#!/bin/sh
#

./configure \
	--prefix=/usr \
	--target-list=arm-softmmu,arm-linux-user \
	--disable-kvm \
	|| exit 1

make && \
make DESTDIR=${1} install || exit 1

#	--disable-sdl \
#	--disable-gfx-check \
#	--cc="gcc -I${1}/usr/include -L${1}/usr/lib" \
