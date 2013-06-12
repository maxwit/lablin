#!/bin/sh

IMG_DIR=/maxwit/image
IMGNAME=$IMG_DIR/disk.img

rm -v $IMGNAME
qemu-img create -f raw $IMGNAME 512M

./sysbuild.sh $IMGNAME
echo
