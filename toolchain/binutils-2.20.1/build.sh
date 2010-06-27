#!/bin/sh
#
# http://www.maxwit.com
# http://maxwit.googlecode.com
#

../${MWP_BINUTILS}/configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${BUILD_PLAT} \
	--target=${TARGET_PLAT} \
	--with-sysroot=${ROOTFS_PATH} \
	--with-gmp=${UTILS_ROOT}/usr \
	--with-mpfr=${UTILS_ROOT}/usr \
	--disable-nls \
	--disable-werror \
	--disable-multilib \
	${BU_CPU_OPT} \
	|| exit 1

make && \
make DESTDIR=${TOOLCHAIN_PATH} install || exit 1

cp -v ../${MWP_BINUTILS}/include/libiberty.h ${ROOTFS_PATH}/usr/include
