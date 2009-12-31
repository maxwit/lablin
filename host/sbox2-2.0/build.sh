#!/bin/sh
#

./autogen.sh && \
make install prefix=${1}/usr || exit 1
