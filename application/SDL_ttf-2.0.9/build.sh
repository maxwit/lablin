#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-sdltest  \
	--without-x \
	|| exit 1

make && \
make DESTDIR=${SYSROOT_PATH} install  || exit 1

#--with-freetype-prefix=${SYSROOT_PATH}/usr/include/freetype2 \
#--with-freetype-exec-prefix=${SYSROOT_PATH}/usr/lib \
