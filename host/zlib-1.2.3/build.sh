#!/bin/sh
#
#


./configure \
	--prefix=/usr \
	--shared || exit 1

make && \
make libz.a || exit 1

make DESTDIR=${UTILS_ROOT} install && \
install -m 755 libz.a ${UTILS_ROOT}/lib || exit 1

