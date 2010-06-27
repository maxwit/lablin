#!/bin/sh

cd src

# if [ ${USER} != root ]; then
# sed -i 's/\(INSTALL.*=\).*/\1 install/' Makefile
# fi

make && make install || exit 1

touch /etc/fstab

cat > /etc/inittab << EOF
# /etc/inittab
id:2:initdefault:
si::sysinit:/etc/init.d/rcS

# What to do when CTRL-ALT-DEL is pressed.
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

# fixme
2:23:respawn:/sbin/agetty 115200 ttyAMA0
EOF


