#!/bin/bash

# username
my_prompt="$my_prompt\[\e[0;32m\]\u\[\e[m\]"

# hostname (pink if its on SSH)
if [ -z "$SSH_CLIENT" ]; then
    my_prompt="$my_prompt@\h "
else
    my_prompt="$my_prompt@\[\e[0;35m\]\h\[\e[m\]"
fi

# rest
my_prompt="$my_prompt \[\e[0;34m\]\w\[\e[m\] \[\e[0;33m\]\$\[\e[m\] "

PS1=$my_prompt
unset my_prompt

# For table titles
export PROMPT_COMMAND='echo -ne "\033]0;$USER@$HOSTNAME: ${PWD/#$HOME/~}\007"'
