#!/bin/sh
#
# http://maxwit.googlecode.com/
#

hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-sdltest \
	--disable-video-x11 \
	--disable-pulseaudio \
	--disable-esd \
	--disable-video-opengl \
	--disable-video-directfb \
    --disable-input-tslib \
    --with-alsa-prefix=${ROOTFS_PATH}/usr/lib/ \
    --with-alsa-inc-prefix=${ROOTFS_PATH}/usr/include \
	|| exit 1

sed -i "s:^prefix=.*:prefix=${ROOTFS_PATH}/usr:" sdl-config

make && \
make DESTDIR=${ROOTFS_PATH} install  || exit 1
sed -i "s:^libdir=.*:libdir=${ROOTFS_PATH}/usr/lib:" ${ROOTFS_PATH}/usr/lib/libSDL.la

echo
echo "Building SDL test case"
cd test && \
hardcode_into_libs=no \
./configure \
	--prefix=/usr \
    --build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--without-x \
	--with-sdl-prefix=${ROOTFS_PATH}/usr \
	--enable-sdltest || exit 1

# fixme
sed -i '/^all/a\\t@cp -v *.bmp *.xbm ${DESTDIR}\/usr' Makefile
sed -i '/^all/a\\t@cp -v $^ ${DESTDIR}\/usr' Makefile

make DESTDIR=${ROOTFS_PATH} || exit 1

echo "OK"
