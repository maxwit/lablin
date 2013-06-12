#!/bin/sh

# usage:
# $0 <image> [board]
# or
# $0 <device> [board]

TOP_DIR=$PWD
IMG_DIR=/maxwit/image
SOURCE=/maxwit/source
BUILD=/maxwit/build
BOOT=$IMG_DIR/boot
ROOTFS=$IMG_DIR/rootfs

# package list
LINUX=linux-3.5.4
BUSYBOX=busybox-1.21.0

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

mkdir -vp ${BOOT} ${ROOTFS}/boot

if [ ! -f "${BOOT}/MLO" ]; then
	if [ ! -d "$BUILD/u-boot" ]; then
		#git clone git://gitorious.org/x-load-omap3/mainline.git $BUILD/x-load
		git clone git://git.denx.de/u-boot.git
	fi
	cd $BUILD/u-boot
	#patch -p1 < ${TOP_DIR}/0001-support-g-bios.patch
	make omap3_beagle_config
	make ARCH=arm CROSS_COMPILE=arm-linux-
	#make CROSS_COMPILE=arm-linux- ift
	cp MLO u-boot.img ${BOOT}/ -v
fi

#if [ ! -f "${BOOT}/g-bios.bin" ]; then
#	if [ ! -d "$BUILD/g-bios" ]; then
#		git clone git://github.com/maxwit/g-bios.git $BUILD/g-bios
#	fi

#	cd $BUILD/g-bios
#	make clean
#	make devkit8000_defconfig
#	make
#	make DESTDIR=${BOOT} install
#fi

if [ ! -f "${ROOTFS}/boot/uImage" ]; then
	echo "building $LINUX ..."

	if [ ! -f "$SOURCE/$LINUX.tar.xz" ]; then
		wget -c http://www.kernel.org/pub/linux/kernel/v3.x/$LINUX.tar.xz -P $SOURCE
	fi

	if [ ! -d "$BUILD/$LINUX" ]; then
		tar xvf $SOURCE/$LINUX.tar.xz -C $BUILD
	fi

	if [ ! -e "$BUILD/$LINUX/arch/arm/boot/uImage" ]; then
		cd $BUILD/$LINUX
		cp -v $TOP_DIR/omap3_defconfig arch/arm/configs/
		make ARCH=arm CROSS_COMPILE=arm-linux- omap3_defconfig
		make ARCH=arm CROSS_COMPILE=arm-linux-
		make ARCH=arm CROSS_COMPILE=arm-linux- uImage
		make ARCH=arm CROSS_COMPILE=arm-linux- INSTALL_MOD_PATH=$ROOTFS modules_install
	fi

	cp $BUILD/$LINUX/arch/arm/boot/uImage ${ROOTFS}/boot/ -v
fi

mkdir -vp ${ROOTFS}/{usr,lib,home,proc,sys,dev,etc,tmp}

if [ ! -e "${ROOTFS}/lib/libc.so" ]; then
	cd /maxwit/toolchain/cortex-a9/
	cp -av --parents `find -name "*.so*"` $ROOTFS
fi

if [ ! -e "${ROOTFS}/sbin/init" ]; then
	if [ ! -d "$BUILD/$BUSYBOX" ]; then
		tar xvf $SOURCE/$BUSYBOX.tar.bz2 -C $BUILD
	fi

	cd $BUILD/$BUSYBOX
	make ARCH=arm defconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-
	make ARCH=arm CROSS_COMPILE=arm-linux- CONFIG_PREFIX=$ROOTFS install
fi

if [ ! -e "${ROOTFS}/etc/init.d/rcS" ]; then
	mkdir -p ${ROOTFS}/etc/init.d/
	cp -av $TOP_DIR/rcS ${ROOTFS}/etc/init.d/
fi

if [ $ISIMG == 1 ]; then
	fdisk $IMG < $TOP_DIR/fdisk.cmd

	sudo losetup -f $IMG
	for i in 1 2; do
		OFF1SEC=`fdisk -l "$IMG" | grep "$IMG$i" | awk {'printf $2'}`
		if [ "$OFF1SEC" == "*" ]; then
			OFF1SEC=`fdisk -l "$IMG" | grep "$IMG$i" | awk {'printf $3'}`
		fi
		OFF1BYTE=$((OFF1SEC*512))
		sudo losetup -o $OFF1BYTE -f $IMG
	done

	DEV0=`sudo losetup -a | sed -n '1p' | awk -F: '{printf $1}'`
	DEV1=`sudo losetup -a | sed -n '2p' | awk -F: '{printf $1}'`
	DEV2=`sudo losetup -a | sed -n '3p' | awk -F: '{printf $1}'`
else
	sudo fdisk $DEV < $TOP_DIR/fdisk.cmd

	case $DEV in
	*mmcblk*)
		DEV1=${DEV}p1
		DEV2=${DEV}p2
		;;
	*sd*)
		DEV1=${DEV}1
		DEV2=${DEV}2
		;;
	*)
		exit 1
		;;
	esac
fi

# fixme: by a partition table
sudo mkfs.msdos -F32 -v -n "boot" $DEV1
sudo mkfs.ext4 -L rootfs $DEV2

mkdir -vp /mnt/{1,2}
sudo mount $DEV1 /mnt/1
sudo mount $DEV2 /mnt/2

sudo cp -v ${BOOT}/* /mnt/1
echo "copying ${ROOTFS}/* /mnt/2 ..."
sudo cp -av ${ROOTFS}/* /mnt/2
echo

sync

sudo umount /mnt/1
sudo umount /mnt/2

if [ $ISIMG == 1 ]; then
	sudo losetup -d $DEV0 $DEV1 $DEV2
fi

sudo qemu-system-arm -M beagle -sd ${IMG} -serial stdio #-net nic -net tap
