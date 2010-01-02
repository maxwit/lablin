#!/bin/sh
#
#

# sed -i 's/\(.*ac_l_default.*= { "\)/\1mad/' libmpcodecs/dec_audio.c

./configure \
	--prefix=/usr \
	|| exit 1

# sed -i '/INSTALLSTRIP/d' config.mak

make && make install || exit 1
