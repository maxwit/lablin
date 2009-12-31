#!/bin/sh
#
# http://maxwit.googlecode.com
# 
#

./configure \
	--prefix=/usr \
	--disable-gl \
	|| exit 1

sed -i -e "/\#define gid_t int/d" -e "/\#define uid_t int/d" config.h

make && make install || exit 1

