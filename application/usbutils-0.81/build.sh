#!/bin/sh
#
#


# ac_cv_lib_usb_usb_get_string_simple=yes \

./configure \
	--prefix=/usr \
	|| exit 1

sed -i '/rpl_malloc/d' config.h
make || exit 1

make install || exit 1

