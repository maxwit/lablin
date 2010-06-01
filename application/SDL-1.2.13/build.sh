#!/bin/sh
#
# http://maxwit.googlecode.com/
#

hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--disable-video-x11 \
	--disable-esd \
	--disable-video-opengl \
	--disable-video-directfb \
    --disable-input-tslib \
    --with-alsa-prefix=${SYSROOT_PATH}/usr/lib/ \
    --with-alsa-inc-prefix=${SYSROOT_PATH}/usr/include \
	|| exit 1

sed -i "s:^prefix=.*:prefix=${SYSROOT_PATH}/usr:" sdl-config

make && \
make DESTDIR=${SYSROOT_PATH} install  || exit 1

#echo
#echo "Building SDL test case"
#hardcode_into_libs=no \
#./configure \
#	--prefix=/usr \
#    --build=${BUILD_PLAT} \
#	--host=${TARGET_PLAT} \
#	--with-sdl-exec-prefix=${SYSROOT_PATH}/usr \
#	--enable-sdltest  || exit
#
#make && \
#make DESTDIR=${SYSROOT_PATH} install  || exit
#echo "OK"
