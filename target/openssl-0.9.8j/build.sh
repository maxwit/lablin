#!/bin/sh
#

./config \
	--openssldir=/usr \
	|| exit 1

# sed -i 's/\(^install:.*\) install_docs/\1/' Makefile
make || exit
make install || exit
