# Audio
alias volu='pactl -- set-sink-volume @DEFAULT_SINK@ +10%'
alias vold='pactl -- set-sink-volume @DEFAULT_SINK@ -10%'
alias mute='dummy audio mute'
alias headphones='dummy audio headphones'
alias rain='curl http://wttr.in/Guildford'
alias nn='dummy nn'

# older servers dont know the tmux TERM type
ssh(){
    local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
    env TERM=$LOCAL_TERM ssh "$@"
}
