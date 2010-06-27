#!/bin/sh
#

./autogen.sh && \
make install prefix=${UTILS_ROOT}/usr || exit 1
