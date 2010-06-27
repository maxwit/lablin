#!/bin/sh
#

./configure \
	--prefix=/usr \
	--with-pc-path=${ROOTFS_PATH}/usr/lib/pkgconfig \
	|| exit 1

make && \
make DESTDIR=${UTILS_ROOT} install || exit 1
