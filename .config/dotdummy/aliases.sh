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
# Get a command from recent history and copy to clipboard
alias hist="fc -l -n -r -100 | awk '{\$1=\$1};1' | fzf --print0 | xsel -b -i"

# older servers dont know the tmux TERM type
ssh(){
    local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
    env TERM=$LOCAL_TERM ssh "$@"
}
