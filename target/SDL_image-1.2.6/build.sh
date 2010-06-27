#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--with-sdl-exec-prefix=${ROOTFS_PATH}/usr \
	--enable-sdltest  \
	|| exit 1

make && \
make DESTDIR=${ROOTFS_PATH} install  || exit 1
