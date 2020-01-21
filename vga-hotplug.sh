#!/bin/bash

# LAPTOP=eDP1
# EXTERNAL=DP1

# #default display
# MONITOR=eDP1

LAPTOP=LVDS1
EXTERNAL=VGA1
#default display
MONITOR=LVDS1

# https://unix.stackexchange.com/questions/227876/how-to-set-custom-resolution-using-xrandr-when-the-resolution-is-not-available-i
# gtf 1920 1080 60
# xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
# xrandr --addmode VGA1 "1920x1080_60.00"
# into script : xrandr --output VGA1 --mode "1920x1080_60.00"
# sh -c "/path/to/the/script.sh"
# functions to switch from LVDS1 to VGA and vice versa
function ActivateVGA {
    #echo "Switching to VGA1"
    #xrandr --output $EXTERNAL --auto --output $LAPTOP --off
    #xrandr --output $EXTERNAL --mode "1920x1080_60.00" --right-of $LAPTOP --output $LAPTOP --auto --primary
    xrandr --output $EXTERNAL --auto --right-of $LAPTOP --output $LAPTOP --auto --primary
    MONITOR=$EXTERNAL
}
function DeactivateVGA {
    #echo "Switching to eDP1"
    xrandr --output $EXTERNAL --off --output $LAPTOP --auto --primary
    MONITOR=$LAPTOP
}

# functions to check if VGA is connected and in use
function VGAActive {
    [ $MONITOR = "$EXTERNAL" ]
}
function VGAConnected {
    ! xrandr | grep "^$EXTERNAL" | grep disconnected >/dev/null
}

# actual script
while true
do
    if ! VGAActive && VGAConnected
    then
	ActivateVGA
    fi

    if VGAActive && ! VGAConnected
    then
	DeactivateVGA
    fi

    sleep 1s
    done
