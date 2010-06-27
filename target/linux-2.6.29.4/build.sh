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
	TARGET_MACH=realview
	;;
esac

if [ -e ${KERNEL_TOP}/${TARGET_MACH}_defconfig ]; then
	cp -v ${KERNEL_TOP}/${TARGET_MACH}_defconfig arch/${TARGET_ARCH}/configs/
elif [ -e arch/${TARGET_ARCH}/configs/${TARGET_MACH}_defconfig ]; then
	sed -i -e 's/# CONFIG_AEABI.*/CONFIG_AEABI=y/' \
		-e '/CONFIG_OABI_COMPAT/d' \
		-e '/CONFIG_AEABI/a\# CONFIG_OABI_COMPAT is not set/' \
		-e 's/\(CONFIG_SYSFS_DEPRECATED.*\)=y/# \1 is not set/' \
		arch/${TARGET_ARCH}/configs/${TARGET_MACH}_defconfig
else
	echo "${TARGET_MACH}: no corresponding kernel configuration found!"
	exit 1
fi

make ${KERN_OPT} ${TARGET_MACH}_defconfig

make ${KERN_OPT} ${BUILD_JOBS} && \
make ${KERN_OPT} modules_install ||  exit 1
echo

case "${TARGET_ARCH}" in
x86 | i386 | x86_64)
	cp -v ${PWD}/arch/${TARGET_ARCH}/boot/bzImage ${IMAGES_PATH}/bzImage.${TARGET_MACH}
	;;

mips*)
	cp vmlinux ${IMAGES_PATH}/vmlinux.${TARGET_MACH}
	;;

*)
	cp arch/${TARGET_ARCH}/boot/zImage ${IMAGES_PATH}/zImage.${TARGET_MACH}
	;;
esac

