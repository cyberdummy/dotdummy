#!/usr/bin/env bash

stty -ixon # disable suspend
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth # ignore commands starting with whitespace & dupes
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

if [[ $(uname -s) == "Darwin" ]]; then
    export IS_MAC=1
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
else
    eval "dircolors ~/.dir_colors" > /dev/null
fi

for file in ~/.config/dotdummy/{exports.sh,aliases.sh,bash_prompt.sh}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset file

TMUX_SESSION=$(tmux display-message -p '#S' 2> /dev/null)
if [[ "$TMUX_SESSION" != "scratch" && -x "$(command -v fish)" ]]; then
  fish
  exit
fi
