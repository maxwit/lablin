#!/bin/sh
#
# http://maxwit.googlecode.com/
#


hardcode_into_libs=no \
./configure \
	--prefix=${SYSROOT_PATH}/usr \
	--disable-video-x11 \
	--disable-esd \
	--disable-video-opengl \
	--disable-video-directfb \
    --disable-input-tslib \
	|| exit 1

make && \
make install  || exit 1

echo
echo "building SDL test ..."
cd test && ./configure --prefix=/usr && make || exit 1

