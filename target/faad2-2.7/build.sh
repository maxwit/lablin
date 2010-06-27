#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-shared \
	--enable-static \
	|| exit 1

make || exit 1
make DESTDIR=${ROOTFS_PATH} install || exit 1


