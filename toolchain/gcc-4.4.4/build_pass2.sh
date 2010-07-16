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
	--with-pkgversion="http://www.maxwit.com, MaxWit Training" \
	--disable-multilib \
	--disable-nls \
	--enable-shared \
	--enable-__cxa_atexit \
	--enable-c99 \
	--enable-long-long \
	--enable-threads=posix \
	--enable-languages=c,c++ \
	${GCC_CPU_OPT} \
	|| exit 1

make AS_FOR_TARGET=${TARGET_PLAT}-as LD_FOR_TARGET=${TARGET_PLAT}-ld && \
make DESTDIR=${TOOLCHAIN_PATH} install || exit 1
