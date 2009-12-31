#!/bin/sh
#
# http://maxwit.googlecode.com/
#

ac_cv_func_malloc_0_nonnull=yes \
CFLAGS=-DUSE_INPUT_API \
./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--enable-shared \
	--disable-ucb1x00 \
	--disable-corgi  \
	--disable-collie  \
	--disable-h3600  \
	--disable-mk712  \
	--disable-arctic2 \
	--enable-input \
	|| exit 1

sed -i 's/# \(module_raw input\)/\1/' etc/ts.conf

make && make install || exit 1

