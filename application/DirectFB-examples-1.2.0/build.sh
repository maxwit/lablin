#!/bin/sh
#
#


# ac_cv_path_PKG_CONFIG=pkg-config

DIRECTFB_CFLAGS="-I/home/conke/maxwit/sysroot/usr/include/directfb" \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make && make DESTDIR=${ROOTFS_PATH} prefix=/usr install || exit 1

