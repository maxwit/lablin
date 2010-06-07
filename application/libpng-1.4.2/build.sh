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
make DESTDIR=${ROOTFS_PATH} install || exit 1
sed -i "s:^libdir=.*:libdir=${ROOTFS_PATH}/usr/lib:" ${ROOTFS_PATH}/usr/lib/libpng12.la
