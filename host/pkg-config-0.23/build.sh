#!/bin/sh
#

./configure \
	--prefix=/usr \
	--with-pc-path=${ROOTFS_PATH}/usr/lib/pkgconfig \
	|| exit 1

make && \
make DESTDIR=${1} install || exit 1
