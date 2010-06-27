#!/bin/sh

# ./Configure -des -Dprefix=/usr
# make && make install

# if [ -n "${TARGET_ARCH}" ]
# then
# 	OPT="CC=gcc OPTIMIZE=\"-march=${TARGET_ARCH}\""
# fi


make -f Makefile.micro && \
cp microperl /usr/bin/perl || exit 1

