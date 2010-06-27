#!/bin/sh
#
# http://www.maxwit.com
# http://maxwit.googlecode.com
#

echo "install_root=${TOOLCHAIN_PATH}" > configparms
libc_cv_forced_unwind=yes \
libc_cv_c_cleanup=yes \
libc_cv_gnu99_inline=yes \
HOST_CC=gcc \
CC="${GLIBC_BUILDING_GCC}" \
AR="${TARGET_PLAT}-ar" \
RANLIB="${TARGET_PLAT}-ranlib" \
../${MWP_GLIBC}/configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	--disable-profile \
	--enable-add-ons \
	--with-tls \
	--enable-kernel=2.6.0 \
	--with-__thread \
	--with-binutils=${TOOLCHAIN_PATH}/usr/bin \
	--with-headers=${TOOLCHAIN_PATH}/usr/include \
	|| exit 1

make && make install || exit 1

# fixme
mkdir -p ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/usr/include ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/usr/lib ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/lib ${ROOTFS_PATH}/ || exit 1
