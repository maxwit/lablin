#!/bin/sh
#
#


ac_cv_path_PKG_CONFIG=pkg-config ./configure --prefix=/usr || exit 1

make && make prefix=/usr install || exit 1

