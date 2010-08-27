#!/bin/sh

export QTOPIA=/work/qtopia
export HOME=$QTOPIA
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$QTOPIA/lib

export QWS_SIZE=800x600
export QWS_KEYBOARD="TTY USB"


## FIXME!
## can't set $PATH in busybox

# export PATH=$PATH:$QTOPIA/bin
qpe &
