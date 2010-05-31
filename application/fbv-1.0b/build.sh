#!/bin/sh
#
#

sed -i '/#include <linux\/fb.h>/d' fb_display.c
sed -i '/stdio.h/a\#include <linux/fb.h>' fb_display.c
sed -i "s/\<cc\>/${TARGET_PLAT}-gcc/" configure

./configure --prefix=/usr --without-libungif # fixme!
sed -i '/mandir/d' Makefile

make CC=${TARGET_PLAT}-gcc && \
make DESTDIR=${SYSROOT_PATH} install || exit 1

