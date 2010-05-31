#!/bin/sh
#
# http://maxwit.googlecode.com/
#

./autogen.sh || exit 1

ac_cv_func_malloc_0_nonnull=yes \
CFLAGS=-DUSE_INPUT_API \
./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--enable-shared \
	--disable-ucb1x00 \
	--disable-corgi  \
	--disable-collie  \
	--disable-h3600  \
	--disable-mk712  \
	--disable-arctic2 \
	--enable-input \
	|| exit 1

# sed -i 's/# \(module_raw input\)/\1/' etc/ts.conf

make && \
make DESTDIR=${SYSROOT_PATH} install && \
make DESTDIR=${ROOTFS_PATH} install || exit 1

