#!/bin/sh

./configure \
	--prefix=/usr \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} || exit

sed -i '/rpl_malloc/d' config.h

make || exit
make DESTDIR=${ROOTFS_PATH} install || exit

sudo chmod -R a+rwx ${ROOTFS_PATH}/usr/include/libusb-1.0
cp ${ROOTFS_PATH}/usr/include/libusb-1.0/libusb.h ${ROOTFS_PATH}/usr/include/
sed -i "s:^libdir=.*$:libdir=\'${ROOTFS_PATH}/usr/lib\':g" ${ROOTFS_PATH}/usr/lib/libusb-1.0.la
