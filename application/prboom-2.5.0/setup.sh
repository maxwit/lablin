#!/bin/sh

CUR_TOP=`dirname $0`

cp -v ${MWP_DOOM_DATA}.gz ${SYSROOT_PATH}/usr/games/ && \
gunzip ${SYSROOT_PATH}/usr/games/${MWP_DOOM_DATA}.gz || exit 1

cat > ${SYSROOT_PATH}/usr/bin/doom << EOF
#!/bin/sh

/usr/games/prboom -iwad /usr/games/${MWP_DOOM_DATA}
EOF

chmod a+x ${SYSROOT_PATH}/usr/bin/doom

echo "DOOM installed OK!"
echo "run \"doom\" to launch the game, enjoy:)"

