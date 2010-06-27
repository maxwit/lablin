#!/bin/sh
#

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make bindir=${UTILS_ROOT}/usr/bin mandir=${UTILS_ROOT}/usr/share/man install || exit 1
