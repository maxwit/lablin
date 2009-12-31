#!/bin/sh
#
# http://maxwit.googlecode.com
#

ac_cv_header_asm_page_h=no \
./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--with-gfxdrivers=none \
	--with-inputdrivers=keyboard,linuxinput,ps2mouse,tslib \
	--enable-fbdev \
	--disable-sdl \
	|| exit 1

make && make install || exit 1

