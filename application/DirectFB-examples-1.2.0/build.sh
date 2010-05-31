#!/bin/sh
#
#

ac_cv_path_PKG_CONFIG=pkg-config 
./configure \
	--prefix=${SYSROOT_PATH}/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

make && make DESTDIR=${SYSROOT_PATH} prefix=/usr install || exit 1

