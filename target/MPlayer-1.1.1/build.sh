#!/bin/sh
#
# Build Applications from scratch (with GPL v2).
#
# Authors:
#	Conke   <conke.hu@gmail.com>
#


sed -i 's/\(.*ac_l_default.*= { "\)/\1mad/' libmpcodecs/dec_audio.c

./configure \
	--prefix=${ROOTFS_PATH}/usr \
	--target=arm-linux \
	--enable-cross-compile \
	--host-cc=gcc \
	--cc=${TARGET_PLAT}-gcc \
	--as=${TARGET_PLAT}-as \
	--ar=${TARGET_PLAT}-ar \
	--ranlib=${TARGET_PLAT}-ranlib \
	|| exit 1

sed -i '/INSTALLSTRIP/d' config.mak

make && make install || exit 1
