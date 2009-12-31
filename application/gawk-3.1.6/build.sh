#!/bin/sh

./configure --prefix=/usr && \
make && make install || exit 1
