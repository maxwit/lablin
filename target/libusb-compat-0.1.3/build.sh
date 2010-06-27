#!/bin/sh

./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-usbmodule  || exit

sed -i '/rpl_malloc/d' config.h

make || exit
make DESTDIR=${ROOTFS_PATH} install || exit
