#!/bin/sh
#

./configure \
	--prefix=/usr \
	--with-xml=expat \
	|| exit 1

make || exit
make install || exit


