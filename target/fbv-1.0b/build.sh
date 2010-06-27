#!/bin/sh
#
#

sed -i '/#include <linux\/fb.h>/d' fb_display.c
sed -i '/stdio.h/a\#include <linux/fb.h>' fb_display.c
sed -i "s/\<cc\>/${TARGET_PLAT}-gcc/" configure

./configure --prefix=/usr && \
sed -i '/mandir/d' Makefile || exit 1

make CC=${TARGET_PLAT}-gcc && \
make DESTDIR=${ROOTFS_PATH} install || exit 1

