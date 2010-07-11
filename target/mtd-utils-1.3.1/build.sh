#!/bin/sh

sed -i '204s/.*/u->v->copy_flag++;/' ubi-utils/old-utils/src/libubigen.c

make CC=${TARGET_PLAT}-gcc WITHOUT_XATTR=1
