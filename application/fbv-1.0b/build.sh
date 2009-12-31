#!/bin/sh
#
#


sed -i '/#include <linux\/fb.h>/d' fb_display.c
sed -i '/stdio.h/a\#include <linux/fb.h>' fb_display.c

sed -i 's/cc/gcc/g' configure

./configure \
	--prefix=/usr \
	--without-libpng \
	|| exit 1	

sed -i '/mandir/d' Makefile

make || exit 1

make  install || exit 1

