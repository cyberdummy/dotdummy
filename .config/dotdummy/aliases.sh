#!/usr/bin/env bash

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
alias ls='ls --color=auto'
alias yank='TZ='America/New_York' date'
alias afk='i3lock -t -i ~/.local/share/wallpapers/cowboy-4k.png'
# Get a command from recent history and copy to clipboard
alias hist="dummy-util hist"
alias dark="~/.dynamic-colors/bin/dynamic-colors switch solarized-dark"
alias light="~/.dynamic-colors/bin/dynamic-colors switch solarized-light"
alias sumcol="dummy-util sumcol"
alias tunes="dummy audio chill"
alias lpr="lpr -o fit-to-page"
alias lpr2="lpr -o fit-to-page -#2"
alias open="xdg-open"
alias ff="dummy ff"
alias slacker="dummy background flatpak run com.slack.Slack"
alias zoomer="dummy background flatpak run us.zoom.Zoom"
alias skyper="dummy background com.skype.Client"
alias mcraft="dummy background com.mojang.Minecraft"
alias vwiki="vim -S ~/.vim/sessions/vimwiki.vim"

# older servers dont know the tmux TERM type
ssh(){
    local LOCAL_TERM
    LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
    env "TERM=$LOCAL_TERM" ssh "$@"
}

local_file="${HOME}/.config/dotdummy/aliases_local.sh"
if [[ -r "$local_file" ]] && [[ -f "$local_file" ]]; then
    source "$local_file"
fi
