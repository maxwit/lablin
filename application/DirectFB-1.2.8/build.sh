#!/bin/sh
#
# http://code.google.com/p/maxwit/
#

#ac_cv_header_asm_page_h=no \
#hardcode_into_libs=no \

TSLIB_CFLAGS=${SYSROOT_PATH}/usr/include \
TSLIB_LIBS=${SYSROOT_PATH}/usr/lib \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
    --with-gfxdrivers=none \
    --disable-x11 \
    --disable-sdl \
    --enable-fbdev \
    --enable-zlib \
    --with-inputdrivers=keyboard,linuxinput,ps2mouse,tslib \
    --disable-video4linux \
    --disable-video4linux2 || exit 1

make || exit
make DESTDIR=${SYSROOT_PATH} install || exit

#sed -i "s:^prefix=/usr$:prefix=${SYSROOT_PATH}/usr:" ${CROSS_PC_PATH}/direct*.pc && \
#sed -i "s:^prefix=/usr$:prefix=${SYSROOT_PATH}/usr:" ${CROSS_PC_PATH}/fusion*.pc || exit 1

