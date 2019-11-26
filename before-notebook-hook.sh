#! /bin/bash -x

if [ ! -f ~/.bashrc ]; then
    cp /etc/skel/.* /etc/skel/* ~
fi
