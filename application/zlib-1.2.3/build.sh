#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--shared || exit 1

make && \
make libz.a || exit 1

make install && \
install -m 755 libz.a /usr/lib || exit 1

