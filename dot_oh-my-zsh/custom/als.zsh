# shorthand
alias py='python'
alias nvm='nvim'
alias e='$EDITOR'
alias ff='fastfetch --logo none'
alias yz='yazi'
alias start='./start.sh'

# convenience - music
alias bcdl='bandcamp-dl --base-dir "$USR_MUSIC_DIR" -er -c "-" -s "-" -x lower --template "$BCDL_TEMPLATE" --cover-quality 0'
alias musformat=$'perl-rename \'s/_/-/g; s/(.*)/\\L$1/\''
alias lrcsort=$'cd $USR_MUSIC_DIR && find . -depth -type f -not -path \'*/.*\' -name "*.lrc" -exec sh -c \'mkdir -p ./.lrc/$(dirname "$1") && mv $1 ./.lrc/$1\' _ {} \\;'
alias lrcformat=$'cd $USR_MUSIC_DIR/.lrc/ && find . -depth -type f -name "*.lrc" -exec sed -i \'s/.*/\\L&/\' {} \\;'
ytdl() {
  read "YTDL_WORKING_DIR?DIR: "
  yt-dlp -x --audio-format mp3 -f bestaudio --embed-metadata --parse-metadata "%(track_number,playlist_index)s:track_number" --parse-metadata "%(album_artist,artist)s:album_artist" --parse-metadata " :genre" --parse-metadata " :comment" --parse-metadata " :disc" -i --min-sleep-interval 6 --max-sleep-interval 18 --sleep-requests 1 --restrict-filenames -P "${YTDL_DIR}/${YTDL_WORKING_DIR}/" -o "$YTDL_FORMAT" "$@"
  musformat "${YTDL_DIR}"/"${YTDL_WORKING_DIR}"/*
}

# convenience - other
alias :q='exit'
alias :wq='exit'
alias q='exit'
alias rsync-exfat='sudo rsync -rltDv --delete --modify-window=1 --progress'
alias aster='astroterm -Cubcl 2.5 -r $(( (0.0+COLUMNS) / (0.0+LINES) ))'
cdgame() { cd $USR_GAME_DIR/$@ }
alias progsync='sync & watch -n 1 grep -e "Dirty:" /proc/meminfo'
rl() { kill -SIGUSR1 $(pgrep $@) }
mvdir() { mkdir -p "${@: -1}" && mv "$@" }
chez() { 
  chezmoi re-add
  git add .
  git branch -M main
  git commit -m '.'
  wl-copy < ~/.git/tk/dot
  git push -u origin main
  wl-copy -c
}
