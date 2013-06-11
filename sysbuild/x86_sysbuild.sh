#!/bin/sh

# usage:
# $0 <image> [board]
# or
# $0 <device> [board]

TOP_DIR=$PWD
SOURCE="/maxwit/source"
BUILD="/maxwit/build"
ROOTFS="/maxwit/image/rootfs"

BUSYBOX="busybox-1.21.0"
ALSA_LIB="alsa-lib-1.0.25"
LINUX="linux-3.8.12"
MPG123="mpg123-1.15.3"

#MACH=`uname -m`
#if [ $MACH = i686 ]; then
#	MACH=i386
#fi
#
#if [ $# != 1 -o ! -e "$1" ]; then
#	echo "usage: $0 <image name>/<device name>"
#	exit 1
#fi
#
#if [ -b $1 ]; then
#	ISIMG=0
#	DEV=$1
#	echo "Using physical device..."
#elif [ -f $1 ]; then
#	ISIMG=1
#	IMG=$1
#	echo "Using image file..."
#else
#	echo "invalid \"$1\"!"
#	exit 1
#fi
#
#mkdir -vp ${ROOTFS}/{usr,lib,boot,proc,sys,dev,etc,var,tmp,root}
#
#echo "building $LINUX ..."
#if [ ! -f "${ROOTFS}/boot/vmlinuz" ]; then
#	cp -v /boot/vmlinuz-`uname -r` ${ROOTFS}/boot/vmlinuz && \
#	cp -v /boot/initrd.img-`uname -r` ${ROOTFS}/boot/initrd.img && \
#	cp -av --parents /lib/modules/`uname -r` $ROOTFS || exit 1
#else
#	cd $BUILD
#	tar xf $SOURCE/$LINUX.tar.xz && \
#	cd $LINUX && \
#	cp -v $TOP_DIR/qemu_defconfig arch/x86/configs/ && \
#	make qemu_defconfig && \
#	make -j2 && \
#	cp -v arch/x86/boot/bzImage $ROOTFS/boot/vmlinuz && \
#	make INSTALL_MOD_PATH=$ROOTFS modules_install || exit 1
#fi
#
#if [ ! -e "${ROOTFS}/lib/libc.so" ]; then
#	cp -av --parents `find /lib /lib64 -name "*.so*"` $ROOTFS || exit 1
#	# fixme
#	cp -av --parents `ls /usr/lib/$MACH-linux-gnu/*w.so*` $ROOTFS || exit 1
#	cp -av --parents `ls /usr/lib/$MACH-linux-gnu/libltdl.so*` ${ROOTFS}
#fi
#
#if [ ! -e "${ROOTFS}/sbin/init" ]; then
#	cd $BUILD
#	tar xf $SOURCE/${BUSYBOX}.tar.bz2
#	cd ${BUSYBOX}
#	make defconfig > /dev/null
#	make
#	make CONFIG_PREFIX=$ROOTFS install
#fi
#
#if [ ! -e "${ROOTFS}/etc/init.d/rcS" ]; then
#	mkdir -p ${ROOTFS}/etc/init.d/
#	cp -av $TOP_DIR/rcS ${ROOTFS}/etc/init.d/
#	cp -av $TOP_DIR/group ${ROOTFS}/etc/
#fi
#
#cd $BUILD
#tar xf $SOURCE/${ALSA_LIB}.tar.bz2
#cd ${ALSA_LIB}
#./configure --prefix=/usr --disable-python
#make
#make DESTDIR=$ROOTFS install
#
#cp -av --parents `which aplay` $ROOTFS/
#
##cd $BUILD
##tar xf $SOURCE/$MPG123.tar.bz2
##cd $MPG123
##./configure --prefix=/usr --with-audio=alsa && \
##make && \
##make DESTDIR=$ROOTFS install || exit 1
#
#cp -v /maxwit/document/appdevel/src/audio/mixer/mixer ${ROOTFS}/usr/bin
#cp -v /usr/share/sounds/alsa/Front_Right.wav ${ROOTFS}

if [ $ISIMG = 1 ]; then
	fdisk $IMG < $TOP_DIR/fdisk.cmd

	losetup -f $IMG

	OFF1SEC=`fdisk -l "$IMG" | grep "${IMG}2" | awk {'printf $2'}`
	if [ "$OFF1SEC" = "*" ]; then
		OFF1SEC=`fdisk -l "$IMG" | grep "${IMG}2" | awk {'printf $3'}`
	fi
	OFF1BYTE=$((OFF1SEC*512))
	losetup -o $OFF1BYTE -f $IMG

	DEV=`losetup -a | sed -n '1p' | awk -F: '{printf $1}'`
	DEV2=`losetup -a | sed -n '2p' | awk -F: '{printf $1}'`
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

MNT="/mnt/2"

sudo mount $DEV2 $MNT

sudo cp -av $ROOTFS/* $MNT/

if [ ! -d "${MNT}/boot/grub" ]; then
	if [ $ISIMG = 1 ]; then
		GRUB_OPT="--modules=part_msdos"
	fi

	grub-install $GRUB_OPT --boot-directory=${MNT}/boot $DEV
	cp -v grub.cfg ${MNT}/boot/grub/
fi

sync && umount $MNT

#if [ $ISIMG = 1 ]; then
#	sudo losetup -d $DEV $DEV2
#	export QEMU_AUDIO_DRV=alsa
#	qemu-system-$MACH $IMG -soundhw ac97
#fi
