#!/bin/sh
#
# Build Mesa for arm.
# http://code.google.com/p/maxwit/
#


# Packages List
GPM=gpm-1.20.5
MesaGLUT=MesaGLUT-7.0.4
MesaDemos=MesaDemos-7.0.4
Mesa=Mesa-7.0.4


cd ${BUILD_PATH}

CHECK_LIST="${GPM}.tar.bz2 ${MesaGLUT}.tar.bz2 ${MesaDemos}.tar.bz2"

for FILE in ${CHECK_LIST}
do
	if [ -e ${SRC_PATH}/${FILE} ]; then
		echo -n "Extracting ${FILE} ..."
		tar jxf ${SRC_PATH}/${FILE}
		echo "OK."
	else
		echo -n "No ${FILE} source package found! skipping building.\n"
        exit 1
	fi
done

if [ ! -e "${SRC_PATH}/patch/Mesa-7.0.4-arm-linux-fbdev.patch" ]; then
	echo -n "No Mesa-7.0.4-arm-linux-fbdev.patch found!\n" 
	exit
fi


echo -n "Building ${GPM} ... "
cd ${BUILD_PATH}/${GPM}
hardcode_into_libs=no \
./configure \
	--prefix=/usr \
	--host=${TARGET_PLAT} > ${LOG_PATH}/${GPM} 2>&1 || exit

make >> ${LOG_PATH}/${GPM} 2>&1 

make DESTDIR=${ROOTFS_PATH} install >> ${LOG_PATH}/${GPM} 2>&1 || exit
echo "OK."


echo -n "Building ${Mesa} ... "
cd ${BUILD_PATH}/${Mesa}
patch -Np1 -i ${SRC_PATH}/patch/Mesa-7.0.4-arm-linux-fbdev.patch > /dev/null || exit
make realclean > ${LOG_PATH}/${Mesa} 2>&1 || exit
make arm-linux-fbdev > ${LOG_PATH}/${Mesa} 2>&1
make install >> ${LOG_PATH}/${Mesa} 2>&1 || exit
echo "OK."


