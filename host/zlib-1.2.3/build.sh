#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--shared || exit 1

make && \
make libz.a || exit 1

make DESTDIR=${1} install && \
install -m 755 libz.a ${1}/lib || exit 1

