#!/bin/sh

if [ "$DESKTOP_SESSION" = "pop-wayland" ]; then 
   # No widgets enabled!
   exit 0
else
   sleep 0s
   killall conky
   cd "$HOME/.config/conky/Mirach"
   conky -c "$HOME/.config/conky/Mirach/Mirach.conf" &
   cd "$HOME/.config/conky/Regulus"
   conky -c "$HOME/.config/conky/Regulus/Regulus.conf" &
   exit 0
fi
