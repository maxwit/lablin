#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-shared \
	--enable-static \
	--with-libpng-compat \
	|| exit 1

make || exit 1
make DESTDIR=${SYSROOT_PATH} install || exit 1
sed -i "s:^libdir=.*:libdir=${SYSROOT_PATH}/usr/lib:" ${SYSROOT_PATH}/usr/lib/libpng12.la
