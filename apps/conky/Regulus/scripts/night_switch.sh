#!/bin/bash
if [[ $(gsettings get org.gnome.settings-daemon.color night-light-enabled) = true ]]; then
    echo " ~/.config/conky/Regulus/res/craby.png"  
else
    echo " ~/.config/conky/Regulus/res/zzz.png"
fi