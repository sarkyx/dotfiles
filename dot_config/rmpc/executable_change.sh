#!/usr/bin/env zsh

source ~/.env/RMPC_DEFAULT_ART_DIR
source ~/.env/USR_MUSIC_DIR

whence -p magick &>/dev/null && magick "$(shuf -n 1 -e $RMPC_DEFAULT_ART_DIR/*)" -gravity center -crop 1:1+0+0 +repage ~/.config/rmpc/default.png &

whence -p exiftool &>/dev/null && exiftool -Picture -b "$USR_MUSIC_DIR/$(mpc current -f %file%)" > /tmp/cover.jpg && notify-send -t 2000 -u low -e -i /tmp/cover.jpg "$(mpc current -f %title%)" "$(mpc current -f %artist%)"
