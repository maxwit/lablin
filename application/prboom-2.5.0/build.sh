#!/bin/sh
#
# http://maxwit.googlecode.com
# 
#

./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--disable-gl \
	|| exit 1

sed -i -e "/\#define gid_t int/d" -e "/\#define uid_t int/d" config.h

make && make DESTDIR=${SYSROOT_PATH} install || exit 1

