#!/bin/sh
#
#

DIRECTFB_CFLAGS="-I${ROOTFS_PATH}/usr/include/directfb" \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make && \
make DESTDIR=${ROOTFS_PATH} prefix=/usr install || exit 1
