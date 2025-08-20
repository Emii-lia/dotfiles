alias please="sudo"
alias pwease="sudo"
alias yamete="shutdown now"
alias python="python3"
alias startu="systemd-analyze"
alias startb="systemd-analyze blame"
alias startc="systemd-analyze critical-chain"
alias btstart="sudo service bluetooth start"
alias netm="sudo service NetworkManager"

# Pop shop aliases
# enable/disable Pop Shop
alias pop-shop-on='sed -i "s/X-GNOME-Autostart-enabled=false/X-GNOME-Autostart-enabled=true/" ~/.config/autostart/io.elementary.appcenter-daemon.desktop; echo "Pop! Store enabled"; nohup io.elementary.appcenter -s >/dev/null 2>&1 &'
alias pop-shop-off='sed -i "s/X-GNOME-Autostart-enabled=true/X-GNOME-Autostart-enabled=false/" ~/.config/autostart/io.elementary.appcenter-daemon.desktop; echo "Pop! Store disabled"; killall io.elementary.appcenter'
