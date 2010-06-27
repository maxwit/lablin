#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--with-sdl-exec-prefix=${ROOTFS_PATH}/usr \
	--with-freetype-prefix=${ROOTFS_PATH}/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-sdltest  \
	--without-x \
	|| exit 1

make && \
make DESTDIR=${ROOTFS_PATH} install  || exit 1

#--with-freetype-prefix=${ROOTFS_PATH}/usr/include/freetype2 \
#--with-freetype-exec-prefix=${ROOTFS_PATH}/usr/lib \
