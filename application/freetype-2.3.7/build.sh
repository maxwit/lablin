#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make || exit 1
make DESTDIR=${SYSROOT_PATH} install && \
sed -i "s:libdir=.*:libdir=${SYSROOT_PATH}/usr/lib:" ${SYSROOT_PATH}/usr/lib/libfreetype.la || exit 1

# objs/libfreetype.la || exit 1
