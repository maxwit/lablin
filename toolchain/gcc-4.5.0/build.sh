#!/bin/sh
#
# http://www.maxwit.com
# http://maxwit.googlecode.com
#

../${MWP_GCC}/configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${BUILD_PLAT} \
	--target=${TARGET_PLAT} \
	--with-sysroot=${ROOTFS_PATH} \
	--with-gmp=${UTILS_ROOT}/usr \
	--with-mpfr=${UTILS_ROOT}/usr \
	--without-headers \
	--with-newlib \
	--disable-multilib \
	--disable-nls \
	--disable-decimal-float \
	--disable-libgomp \
	--disable-libmudflap \
	--disable-libssp \
	--disable-shared \
	--disable-threads \
	--enable-long-long \
	--enable-languages=c \
	${GCC_CPU_OPT} \
	|| exit 1

make && \
make DESTDIR=${TOOLCHAIN_PATH} install || exit 1
