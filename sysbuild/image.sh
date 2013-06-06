#!/bin/sh

IMG_DIR=/maxwit/image
IMGNAME=$IMG_DIR/disk.img

rm -v $IMGNAME && \
qemu-img create -f raw $IMGNAME 512M

./x86_sysbuild.sh $IMGNAME
echo
