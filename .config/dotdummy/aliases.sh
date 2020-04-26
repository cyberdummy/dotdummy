# Audio
alias volu='pactl -- set-sink-volume @DEFAULT_SINK@ +10%'
alias vold='pactl -- set-sink-volume @DEFAULT_SINK@ -10%'
alias mute='dummy audio mute'
alias headphones='dummy audio headphones'
alias rain='curl http://wttr.in/Guildford'
alias nn='dummy nn'
alias pdf='zathura'
alias cdg='cd $(git root)'
alias ll='ls -lah'
alias yank='TZ='America/New_York' date'
alias afk='i3lock -t -i ~/.local/share/wallpapers/cowboy-4k.jpg'
# Get a command from recent history and copy to clipboard
alias hist="fc -l -n -r -3000 | awk '{\$1=\$1};1' | fzf --print0 | xsel -b -i"
alias dark="sed -i 's/colors: \*light/colors: \*dark/g' ~/.config/alacritty/alacritty.yml"
alias light="sed -i 's/colors: \*dark/colors: \*light/g' ~/.config/alacritty/alacritty.yml"
alias sumcol="paste -sd+ - | bc"

# older servers dont know the tmux TERM type
ssh(){
    local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
    env TERM=$LOCAL_TERM ssh "$@"
}

# Transform a zoom meeting URL into one to launch zoom with
zoomzoom(){
    local id=$(echo "$1" | cut -d '/' -f5 | cut -d '?' -f1)
    local query=$(echo "$1" | cut -d '?' -f2)

    local running=$(docker ps | grep zoom | wc -l)
    local url="zoommtg://zoom.us/join?action=join&confno=$id&$query"

    if [ "$running" -eq "1" ]; then
        docker exec zoom zoom "$url"
    else
        zoom "$url"
    fi
}

countdown(){
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
    done
}

stopwatch(){
    date1=`date +%s`;
    while true; do
    days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
    done
}
