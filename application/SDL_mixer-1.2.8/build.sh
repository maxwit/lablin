#!/bin/sh
#
# http://maxwit.googlecode.com/
#

sed -i "s:\"SDL.h\":<SDL/SDL.h>:" timidity/timidity.c effect_stereoreverse.c playwave.c effect_position.c playmus.c

hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--with-sdl-exec-prefix=${SYSROOT_PATH}/usr \
	--enable-sdltest  \
    --disable-music-mp3 \
	|| exit 1

make && \
make DESTDIR=${SYSROOT_PATH} install  || exit 1
