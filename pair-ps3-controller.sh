#!/bin/bash

export SIXPAIR_PATH=${SIXPAIR_PATH:-./sixpair}

if [ ! -f $SIXPAIR_PATH/sixpair ]; then
    if [ ! -f $SIXPAIR_PATH/sixpair.c ]; then
        echo "'sixpair.c' not found in SIXPAIR_PATH"
        exit 1
    fi

    echo "Performing first-time setup..."

    echo "Installing libusb-dev..."
    sudo apt-get install libusb-dev -y || exit 1

    echo "Compiling sixpair executable..."
    gcc -o $SIXPAIR_PATH/sixpair $SIXPAIR_PATH/sixpair.c -lusb || exit 1

    echo "First-time setup completed"
    echo ""
fi

echo "Please plug in your PS3 controller via USB"
echo ""
read -p "Press ENTER to continue or Ctrl+C to exit..."
echo ""
echo "Attempting to set new Bluetooth host on controller..."

if ! sudo $SIXPAIR_PATH/sixpair ; then
    echo "ERROR: Failed to set new Bluetooth host on controller."
    exit 1
fi

echo ""
echo "Please check the log above"
echo "If setting a new Bluetooth host failed, this script will be unable to pair with your controller"
echo "If this happens, please exit this script and try to rectify the issue"
echo ""
echo "PS3 controller pairing instructions:"
echo ""
echo "1.  A bluetoothctl prompt will now open"
echo "2.  Leave bluetoothctl open without doing anything"
echo "3.  Press the PlayStation button on your controller"
echo "4.  Unplug your PS3 controller"
echo "5.  Plug your PS3 controller back in"
echo "6.  Bluetoothctl will now ask you to pair with your controller. Type \"yes\" and press ENTER"
echo ""
echo "    6a. If this is the first time you pair this controller, copy the MAC address of the controller"
echo "        from the bluetoothctl log and type \"trust INSERT_MAC_ADDRESS_HERE\" and press ENTER."
echo "        This will allow the controller to pair automatically in the future when it's turned on."
echo ""
echo "7.  Exit bluetoothctl by typing \"quit\""
echo "8.  Your PS3 controller should now be paired!"
echo ""
read -p "Press ENTER to continue or Ctrl+C to exit..."
echo ""

sudo bluetoothctl
