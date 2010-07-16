#!/bin/sh
#
# http://www.maxwit.com
# http://maxwit.googlecode.com


sed -i 's/-lgcc_eh//g' ../${MWP_GLIBC}/Makeconfig

echo libc_cv_forced_unwind=yes > config.cache
echo libc_cv_c_cleanup=yes >> config.cache
echo libc_cv_gnu89_inline=yes >> config.cache
echo "install_root=${TOOLCHAIN_PATH}" >> configparms

BUILD_CC="gcc" \
CC="${GLIBC_BUILDING_GCC}" \
AR="${TARGET_PLAT}-ar" \
RANLIB="${TARGET_PLAT}-ranlib" \
../${MWP_GLIBC}/configure \
    --host=${TARGET_PLAT} \
    --build=${BUILD_PLAT} \
    --prefix=/usr \
    --disable-profile \
    --enable-kernel=2.6.0 \
	--enable-add-ons \
    --with-tls \
    --with-__thread \
    --with-binutils=${TOOLCHAIN_PATH}/usr/bin \
    --with-headers=${TOOLCHAIN_PATH}/usr/include \
    --cache-file=config.cache \
    || exit 1

make && make install || exit 1

fixme
mkdir -p ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/usr/include ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/usr/lib ${ROOTFS_PATH}/usr && \
cp -av ${TOOLCHAIN_PATH}/lib ${ROOTFS_PATH}/ || exit 1
