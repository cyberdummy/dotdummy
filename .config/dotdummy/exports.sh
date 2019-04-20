#!/bin/bash

export EDITOR=vim
export BROWSER=firefox
export SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh
export PATH=~/.local/bin:$PATH
export GOPATH="${HOME}/code/go/gopath"
export UID

for lang in $lang en_GB.utf8 en_US.utf8; do
    if locale -a | grep ^"$lang"$ >/dev/null 2>&1 ; then
        export LANG=$lang
        break
    fi
done
