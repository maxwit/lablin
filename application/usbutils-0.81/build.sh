#!/bin/sh
#
# Authors:
#	Conke Hou  <conke@maxwit.com>
#


./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-usbmodule || exit

sed -i '/rpl_malloc/d' config.h

make || exit
make DESTDIR=${SYSROOT_PATH} install || exit
