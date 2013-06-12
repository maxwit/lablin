#!/bin/sh

IMG_DIR=/maxwit/image
IMGNAME=$IMG_DIR/disk.img

rm -vf $IMGNAME
qemu-img create -f raw $IMGNAME 512M

./sysbuild.sh $IMGNAME
echo
