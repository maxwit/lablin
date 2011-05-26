#!/bin/sh
#
# Handle the main menu for building MaxWit Lablin
#
# http://www.maxwit.com
# http://maxwit.googlecode.com
#
# Authors:
#     Conke Hu    <conke@maxwit.com>
#     Tiger Yu    <tiger@maxwit.com>
#     Fleya Hou   <fleya@maxwit.com>
#


KERNEL_TOP="${MW_TOP_DIR}/target/${MWP_KERNEL}"
KERN_OPT="ARCH=arm CROSS_COMPILE=${TARGET_PLAT}- INSTALL_MOD_PATH=${ROOTFS_PATH}"

case "${TARGET_SOC}" in
*)
	BOARD_NAME=realview
	;;
esac

if [ -e ${KERNEL_TOP}/${BOARD_NAME}_defconfig ]; then
	cp -v ${KERNEL_TOP}/${BOARD_NAME}_defconfig arch/${TARGET_ARCH}/configs/
elif [ -e arch/${TARGET_ARCH}/configs/${BOARD_NAME}_defconfig ]; then
	sed -i -e 's/# CONFIG_AEABI.*/CONFIG_AEABI=y/' \
		-e '/CONFIG_OABI_COMPAT/d' \
		-e '/CONFIG_AEABI/a\# CONFIG_OABI_COMPAT is not set/' \
		-e 's/\(CONFIG_SYSFS_DEPRECATED.*\)=y/# \1 is not set/' \
		arch/${TARGET_ARCH}/configs/${BOARD_NAME}_defconfig
else
	echo "${BOARD_NAME}: no corresponding kernel configuration found!"
	exit 1
fi

make ${KERN_OPT} ${BOARD_NAME}_defconfig

make ${KERN_OPT} ${BUILD_JOBS} && \
make ${KERN_OPT} modules_install ||  exit 1
echo

case "${TARGET_ARCH}" in
x86 | i386 | x86_64)
	cp -v ${PWD}/arch/${TARGET_ARCH}/boot/bzImage ${IMAGE_PATH}/bzImage.${BOARD_NAME}
	;;

mips*)
	cp vmlinux ${IMAGE_PATH}/vmlinux.${BOARD_NAME}
	;;

*)
	cp arch/${TARGET_ARCH}/boot/zImage ${IMAGE_PATH}/zImage.${BOARD_NAME}
	;;
esac

