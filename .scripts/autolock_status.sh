#!/bin/bash
autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [ "$autolock" != "" ]; then
    echo "<fc=#212121></fc>"
else
    echo "<fc=#afa193></fc>"
fi
