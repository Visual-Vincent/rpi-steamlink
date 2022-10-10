#!/bin/bash

# Big thank you to Ian Colwell for making this script and finding out how to install Steam Link on Raspberry Pi OS (Bullseye)!
# https://blog.iancolwell.ca/steamlink-aarch64
# https://github.com/icolwell/install_scripts/blob/master/steamlink_install.bash
#
# Copyright (c) 2019 Ian Colwell
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

CODENAME="$(lsb_release -sc)"
ARCH="$(arch)"

if [ "$CODENAME" != "bullseye" ] || [ "$ARCH" != "aarch64" ]; then
    echo "This script has not been tested on anything other than 64-bit Raspberry Pi OS 11 (bullseye, aarch64)"
    echo "If you are running 32-bit Raspberry Pi OS, you can likely just run 'sudo apt install steamlink'"
    exit 1
fi

# Install steamlink
sudo apt-get -y install steamlink

# Run steamlink at least once for setup prompts
steamlink

# Missing dependencies
sudo apt-get -y install libgles2:armhf libegl1:armhf libgl1-mesa-glx:armhf libsndio7.0:armhf libavcodec58:armhf

# Symlink library versions
cd "/lib/arm-linux-gnueabihf"

sudo ln -s libbcm_host.so.0 libbcm_host.so
sudo ln -s libvcsm.so.0 libvcsm.so
sudo ln -s libmmal.so.0 libmmal.so
sudo ln -s libmmal_core.so.0 libmmal_core.so
sudo ln -s libmmal_util.so.0 libmmal_util.so

echo ""
echo "Steamlink installed :)"

# Addition made by Visual Vincent, 2022-10-10
if [ "$(grep -oP 'dtoverlay=vc4-fkms-v3d' /boot/config.txt)" == "" ]; then
    echo ""
    echo "WARNING: You appear to be using the full KMS driver."
    echo "         At the time of writing this script, Steam Link seems to only support running with the fake KMS driver."
    echo "         If you get a black screen when connecting to a PC or starting a game,"
    echo "         try switching to the fake KMS driver instead by:"
    echo ""
    echo "         Editing /boot/config.txt and adding or changing the line:"
    echo ""
    echo "             # Enable DRM VC4 V3D driver"
    echo "             dtoverlay=vc4-kms-v3d"
    echo ""
    echo "         to:"
    echo ""
    echo "             # Enable DRM VC4 V3D driver"
    echo "             dtoverlay=vc4-fkms-v3d"
    echo ""
    echo "         Refer to Ian Colwell's blog for more information:"
    echo "         https://blog.iancolwell.ca/steamlink-aarch64"
fi

set +e
