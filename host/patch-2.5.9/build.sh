#!/bin/sh
#

./configure \
	--prefix=/usr \
	|| exit 1

make && \
make bindir=${1}/usr/bin mandir=${1}/usr/share/man install || exit 1
