#!/bin/bash

for device in $(bluetoothctl devices | grep -oP "([[:xdigit:]]{2}:){5}([[:xdigit:]]{2})"); do
    echo "Disconnecting Bluetooth device: $device"
    bluetoothctl disconnect "$device"
done
