#!/bin/sh

BB_PWD=`dirname $0`

cp ${BB_PWD}/defconfig scripts/ && \
make defconfig && \
make CONFIG_PREFIX=/ install || exit 1

# cat > /etc/init.d/rcS << EOF
# #!/bin/sh
# 
# [ -e /dev/console ] || mknod /dev/console c 5 1
# 
# echo
# echo "    ***********************************"
# echo "    *    Welcome to MaxWit Linux !    *"
# echo "    *    [ http://www.maxwit.com ]    *"
# echo "    ***********************************"
# echo
# 
# mount -t sysfs sysfs  /sys
# mount -t tmpfs tmpfs  /dev
# mount -t proc  proc   /proc
# mount -t tmpfs tmpfs  /tmp
# 
# EOF
# 
# chmod 755 /etc/init.d/rcS

