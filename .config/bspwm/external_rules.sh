#! /bin/sh

wid=$1
class=$2
#instance=$3
#consequences=$4

shopt -s nocasematch

if [[ "$class" == *"Minecraft"* ]] || [[ "$class" == *"minecraft"* ]] || [[ "$class" == *"PrismLauncher"* ]]; then
    echo "desktop=five"
    exit 0
fi

# slow to set props
if [[ "$class" == "" ]]; then
  sleep 0.5
  wm_class=($(xprop -id $wid | grep "WM_CLASS" | grep -Po '"\K[^,"]+'))

  if [[ "$wm_class" == *"Minecraft"* ]] || [[ "$wm_class" == *"minecraft"* ]]; then
      echo "desktop=five"
      exit 0
  fi
fi
