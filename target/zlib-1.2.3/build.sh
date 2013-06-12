#!/bin/sh
#
#

CC=${TARGET_PLAT}-gcc AR=${TARGET_PLAT}-ar ./configure \
	--prefix=${ROOTFS_PATH}/usr \
	|| exit 1

# sed -i "s/=gcc/=${TARGET_PLAT}-gcc/" Makefile
# sed -i -e "s/LDSHARED=gcc/LDSHARED=${TARGET_PLAT}-gcc/" -e "s/CC=gcc/CC=${TARGET_PLAT}-gcc/" Makefile

make || exit 1

make install || exit 1

