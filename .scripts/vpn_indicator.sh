#!/bin/bash

vpn=$((pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1 && echo down) | head -n 1)

if [ "$vpn" = "down" ]; then
    echo "<fc=#212121></fc>"
else
    echo "<fc=#afa193></fc>"
fi
