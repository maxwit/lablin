#!/bin/sh

UDEV_TOP=`dirname $0`

./configure \
	--prefix=/usr \
	--exec-prefix= \
	--sysconfdir=/etc \
	--build=${BUILD_PLAT} \
	--host=${TARGET_PLAT} \
	|| exit 1

# sed -i '/open.*null.*O_/i\\tmknod("/dev/null", S_IFCHR | 0666, makedev(1, 3));' udev/udevd.c
# sed -i '/in,out,err/,+10d' udev/udevd.c
# sed -i 's/udevtrigger/udevadm trigger/' /etc/init.d/rcS

make && \
make DESTDIR=${ROOTFS_PATH} install || exit 1

cp ${UDEV_TOP}/udev.rules ${ROOTFS_PATH}/etc/udev/rules.d/ || exit 1

cat >> ${ROOTFS_PATH}/etc/init.d/rcS << EOF

echo -n "Starting udev .."
udevd --daemon
echo -n "."
udevadm trigger
echo " OK."

EOF

