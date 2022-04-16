#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if [ "$2" == "framework" ]; then
  DEVICE="$HOME/.config/polybar/nord/framework-config"
else
  DEVICE="$HOME/.config/polybar/nord/desktop-config"
fi

# Launch bar1 and bar2
if [ "$1" == "light" ]; then
  polybar -l warning -c "$HOME/.config/polybar/nord/light-config" nord-top &
  #polybar -c $HOME/.config/polybar/nord/light-config nord-down &
else
  DEVICE=$DEVICE polybar -l warning -c "$HOME/.config/polybar/nord/dark-config" nord-top &
  #polybar -c $HOME/.config/polybar/nord/dark-config nord-down &
fi

echo "Bars launched..."
