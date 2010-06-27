#!/bin/sh
#

./configure \
	--prefix=/usr \
	--target-list=arm-softmmu,arm-linux-user \
	--disable-kvm \
	|| exit 1

make && \
make DESTDIR=${UTILS_ROOT} install || exit 1

#	--disable-sdl \
#	--disable-gfx-check \
#	--cc="gcc -I${UTILS_ROOT}/usr/include -L${UTILS_ROOT}/usr/lib" \
