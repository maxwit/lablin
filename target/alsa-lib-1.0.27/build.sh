#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-shared \
	--disable-python \
	|| exit 1

# --enable-static

make || exit 1
make DESTDIR=${ROOTFS_PATH} install || exit 1


