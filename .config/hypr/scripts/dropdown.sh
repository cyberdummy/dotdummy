#!/usr/bin/env bash

TOGGLE=/tmp/droptoggle
DROPTERM=term-dropdown

if [ -f "$TOGGLE" ]; then
    #Hide terminal and unpin
	hyprctl --batch "dispatch movewindowpixel 0 -600,$DROPTERM; dispatch pin $DROPTERM; dispatch cyclenext"
	rm $TOGGLE
else
    #Show terminal and pin
    hyprctl --batch "dispatch movewindowpixel 0 600,$DROPTERM; dispatch pin $DROPTERM; dispatch focuswindow $DROPTERM"
    touch $TOGGLE
fi
