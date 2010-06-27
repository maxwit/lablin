#!/bin/sh

sed -i "7s:^ifndef PREFIX:\#ifndef PREFIX:g" ${ROOTFS_PATH}/../build/application/wireless_tools.29/Makefile
sed -i "9s:^endif:PREFIX=${ROOTFS_PATH}\/usr:g" ${ROOTFS_PATH}/../build/application/wireless_tools.29/Makefile
sed -i "s:^CC = gcc:CC=arm-linux-gcc:g" ${ROOTFS_PATH}/../build/application/wireless_tools.29/Makefile
sed -i "s:^AR =.*$:AR=arm-linux-ar:g" ${ROOTFS_PATH}/../build/application/wireless_tools.29/Makefile
sed -i "s:^RANLIB =.*$:RANLIB=arm-linux-ranlib:g" ${ROOTFS_PATH}/../build/application/wireless_tools.29/Makefile

make || exit
make install || exit
