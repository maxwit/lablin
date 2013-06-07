#!/bin/sh

# usage:
# $0 <image> [board]
# or
# $0 <device> [board]

TOP_DIR=$PWD
SOURCE=/maxwit/source
BUILD=/maxwit/build
ROOTFS="/mnt/2"

BUSYBOX="busybox-1.21.0"
ALSA_LIB="alsa-lib-1.0.27"
LINUX="linux-3.8.12"
MPG123="mpg123-1.15.3"

MACH=`uname -m`
if [ $MACH = i686 ]; then
	MACH=i386
fi

if [ $# != 1 -o ! -e "$1" ]; then
	echo "usage: $0 <image name>/<device name>"
	exit 1
fi

if [ -b $1 ]; then
	ISIMG=0
	DEV=$1
	echo "Using physical device..."
elif [ -f $1 ]; then
	ISIMG=1
	IMG=$1
	echo "Using image file..."
else
	echo "invalid \"$1\"!"
	exit 1
fi

if [ $ISIMG = 1 ]; then
	fdisk $IMG < $TOP_DIR/fdisk.cmd

	sudo losetup -f $IMG

	OFF1SEC=`fdisk -l "$IMG" | grep "${IMG}2" | awk {'printf $2'}`
	if [ "$OFF1SEC" = "*" ]; then
		OFF1SEC=`fdisk -l "$IMG" | grep "${IMG}2" | awk {'printf $3'}`
	fi
	OFF1BYTE=$((OFF1SEC*512))
	sudo losetup -o $OFF1BYTE -f $IMG

	DEV=`sudo losetup -a | sed -n '1p' | awk -F: '{printf $1}'`
	DEV2=`sudo losetup -a | sed -n '2p' | awk -F: '{printf $1}'`
else
	sudo fdisk $DEV < $TOP_DIR/fdisk.cmd

	case $DEV in
	*mmcblk*)
		DEV2=${DEV}p2
		;;
	*sd*)
		DEV2=${DEV}2
		;;
	*)
		exit 1
		;;
	esac
fi

# fixme: by a partition table
sudo mkfs.ext4 -L rootfs $DEV2

sudo mkdir -vp $ROOTFS
sudo mount $DEV2 $ROOTFS

if [ ! -d "${BOOT}/grub" ]; then
	if [ $ISIMG = 1 ]; then
		GRUB_OPT="--modules=part_msdos"
	fi

	sudo grub-install $GRUB_OPT --boot-directory=${ROOTFS}/boot $DEV
	sudo cp -v grub.cfg ${ROOTFS}/boot/grub/
fi

echo "building $LINUX ..."
if [ ! -f "${ROOTFS}/boot/vmlinuz" ]; then
	sudo cp /boot/vmlinuz-`uname -r` ${ROOTFS}/boot/vmlinuz -v
	sudo cp /boot/initrd.img-`uname -r` ${ROOTFS}/boot/initrd.img -v
	sudo cp -av --parents /lib/modules/`uname -r` $ROOTFS || exit 1
else
	cd $BUILD
#	tar xf $SOURCE/$LINUX.tar.xz && \
	cd $LINUX && \
	cp -v $TOP_DIR/qemu_defconfig arch/x86/configs/ && \
	make qemu_defconfig && \
	make -j2 && \
	sudo cp -v arch/x86/boot/bzImage $ROOTFS/boot/vmlinuz && \
	sudo make INSTALL_MOD_PATH=$ROOTFS modules_install || exit 1
fi

sudo mkdir -vp ${ROOTFS}/{usr,lib,home,proc,sys,dev,etc,tmp}

if [ ! -e "${ROOTFS}/lib/libc.so" ]; then
	sudo cp -av --parents `find /lib /lib64 -name "*.so*"` $ROOTFS || exit 1
	# fixme
	sudo cp -av --parents `ls /usr/lib/$MACH-linux-gnu/*w.so*` $ROOTFS || exit 1
	sudo cp -av --parents `ls /usr/lib/$MACH-linux-gnu/libltdl.so*` ${ROOTFS}
fi

if [ ! -e "${ROOTFS}/sbin/init" ]; then
	cd $BUILD
	tar xf $SOURCE/${BUSYBOX}.tar.bz2
	cd ${BUSYBOX}
	make defconfig > /dev/null
	make
	sudo make CONFIG_PREFIX=$ROOTFS install
fi

if [ ! -e "${ROOTFS}/etc/init.d/rcS" ]; then
	sudo mkdir -p ${ROOTFS}/etc/init.d/
	sudo cp -av $TOP_DIR/rcS ${ROOTFS}/etc/init.d/
	sudo touch ${ROOTFS}/etc/group
fi

#sudo cp -av --parents `find /usr/lib -name "libasound*.so*"` $ROOTFS/
#sudo cp -av --parents /usr/share/alsa* $ROOTFS/

cd $BUILD
tar xf $SOURCE/${ALSA_LIB}.tar.bz2
cd ${ALSA_LIB}
./configure --prefix=/usr --disable-python
make
sudo make DESTDIR=$ROOTFS install

sudo cp -av --parents `which aplay` $ROOTFS/

cd $BUILD
tar xf $SOURCE/$MPG123.tar.bz2
cd $MPG123
./configure --prefix=/usr --with-audio=alsa && \
make && \
sudo make DESTDIR=$ROOTFS install || exit 1

sudo cp -v /maxwit/document/appdevel/src/audio/mixer/mixer ${ROOTFS}
sudo cp -v /usr/share/sounds/alsa/Front_Right.wav ${ROOTFS}

sync && sudo umount /mnt/2

if [ $ISIMG = 1 ]; then
	sudo losetup -d $DEV $DEV2
	qemu-system-$MACH $IMG -soundhw ac97
fi
