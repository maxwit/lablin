#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make || exit 1
make DESTDIR=${ROOTFS_PATH} install && \
sed -i "s:libdir=.*:libdir=${ROOTFS_PATH}/usr/lib:" ${ROOTFS_PATH}/usr/lib/libfreetype.la || exit 1

# objs/libfreetype.la || exit 1
