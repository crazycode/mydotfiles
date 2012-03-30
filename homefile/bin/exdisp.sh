#!/bin/bash
# External output may be "VGA" or "VGA-0" or "DVI-0" or "TMDS-1"
EXTERNAL_OUTPUT="VGA1"
INTERNAL_OUTPUT="LVDS1"
# EXTERNAL_LOCATION may be one of: left, right, above, or below
#EXTERNAL_LOCATION="left"
EXTERNAL_LOCATION=$1

case "$EXTERNAL_LOCATION" in
       same|SAME)
               EXTERNAL_LOCATION="--same-as $INTERNAL_OUTPUT"
               ;;
       off|OFF)
               EXTERNAL_LOCATION="--off"
               ;;
       left|LEFT)
               EXTERNAL_LOCATION="--left-of $INTERNAL_OUTPUT"
               ;;
       right|RIGHT)
               EXTERNAL_LOCATION="--right-of $INTERNAL_OUTPUT"
               ;;
       top|TOP|above|ABOVE)
               EXTERNAL_LOCATION="--above $INTERNAL_OUTPUT"
               ;;
       bottom|BOTTOM|below|BELOW)
               EXTERNAL_LOCATION="--below $INTERNAL_OUTPUT"
               ;;
       *)
               #EXTERNAL_LOCATION="--left-of $INTERNAL_OUTPUT"
               EXTERNAL_LOCATION="--off"
               ;;
esac

xrandr |grep $EXTERNAL_OUTPUT | grep " connected "
if [ $? -eq 0 ]; then
    echo "xrandr --output $INTERNAL_OUTPUT --auto --primary --output $EXTERNAL_OUTPUT --auto $EXTERNAL_LOCATION"
    xrandr --output $EXTERNAL_OUTPUT --mode 1280x800
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto $EXTERNAL_LOCATION
    #
    #xrandr --output $INTERNAL_OUTPUT --primary --auto --output $EXTERNAL_OUTPUT --auto --right-of LVDS --pos 1280x0
    #xrandr --output $INTERNAL_OUTPUT --primary --auto --output $EXTERNAL_OUTPUT --auto --right-of $INTERNAL_OUTPUT
    # Alternative command in case of trouble:
    # (sleep 2; xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto $EXTERNAL_LOCATION) &
else
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
fi

