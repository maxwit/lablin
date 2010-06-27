#!/bin/sh
#


./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make && \
make DESTDIR=${ROOTFS_PATH} install || exit
