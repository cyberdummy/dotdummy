#!/usr/bin/env bash

alias volu='pactl -- set-sink-volume @DEFAULT_SINK@ +10%'
alias vold='pactl -- set-sink-volume @DEFAULT_SINK@ -10%'
alias mute='dummy audio mute'
alias headphones='dummy audio headphones'
alias rain='curl http://wttr.in/Guildford'
alias nn='dummy nn'
alias pdf='zathura'
alias cdg='dummy-code cdg'
alias ll='ls -lah'
alias ls='ls --color=auto'
alias yank='TZ='America/New_York' date'
alias afk='dummy lock'
alias hist="dummy-util hist"
alias dark="~/.dynamic-colors/bin/dynamic-colors switch solarized-dark"
alias light="~/.dynamic-colors/bin/dynamic-colors switch solarized-light"
alias sumcol="dummy-util sumcol"
alias tunes="dummy audio chill"
alias lpr="lpr -o fit-to-page"
alias lpr2="lpr -o fit-to-page -#2"
alias open="xdg-open"
alias ff="dummy ff"
alias ffvpn="dummy ffvpn"
alias slacker="dummy background flatpak run com.slack.Slack --force-device-scale-factor=1.25"
alias zoomer="dummy background flatpak run us.zoom.Zoom"
alias skyper="dummy background com.skype.Client"
alias mcraft="dummy background com.mojang.Minecraft"
alias vwiki="vim -S ~/.vim/sessions/vimwiki.vim -c VimwikiIndex"
alias ding="paplay /usr/share/sounds/freedesktop/stereo/complete.oga"
alias bc="bc -l"
alias mux="tmuxinator start"
alias ai="dummy chatblade"
