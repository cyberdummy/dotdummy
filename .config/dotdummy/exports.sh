#!/bin/bash

export EDITOR=vim
export BROWSER=firefox
export SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh
export PATH=~/.local/bin:~/.config/composer/vendor/bin:$PATH
export GOPATH="${HOME}/code/go/gopath"
export PERL_DESTRUCT_LEVEL=2 # stops urxvt exit crash on arch for some reason
export UID

for lang in en_GB.utf8 en_US.utf8; do
    if locale -a | grep ^"$lang"$ >/dev/null 2>&1 ; then
        export LANG=$lang
        break
    fi
done

if [[ -n "${IS_MAC-}" ]]; then
    export CLICOLOR=YES
    export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
    gpg-agent --daemon --pinentry-program /usr/local/bin/pinentry-mac 2> /dev/null
fi

export DYNAMIC_COLORS_ROOT=~/.config/dynamic-colors
export GDK_DPI_SCALE=0.8
